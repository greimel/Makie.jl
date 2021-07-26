using Chain
using Markdown
using GLMakie
using FileIO
using ImageTransformations
using Colors

include("colormap_generation.jl")

# Pause renderloop for slow software rendering.
# This way, we only render if we actualy save e.g. an image
GLMakie.set_window_config!(;
    framerate = 15.0,
    pause_rendering = true
)


function hfun_bar(vname)
  val = Meta.parse(vname[1])
  return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
  var = vname[1]
  return pagevar("index", var)
end


function hfun_doc(params)
  fname = params[1]
  head = length(params) > 1 ? params[2] : fname
  type = length(params) == 3 ? params[3] : ""
  doc = eval(Meta.parse("using Makie; @doc Makie.$fname"))
  txt = Markdown.plain(doc)
  # possibly further processing here
  #body = Markdown.html(Markdown.parse(txt))
  body = fd2html(txt, internal = true)
  return """
    <div class="docstring">
        <h2 class="doc-header" id="$fname">
          <a href="#$fname">$head</a>
          <div class="doc-type">$type</div>
        </h2>
        <div class="doc-content">$body</div>
    </div>
  """
end


function env_examplefigure(com, _)
  content = Franklin.content(com)

  _, middle = split(content, r"```(julia)?", limit = 2)
  kwargs = eval(Meta.parse("Dict(pairs((;" * Franklin.content(com.braces[1]) * ")))"))

  name = get(kwargs, :name, "example_" * string(hash(content)))
  svg = get(kwargs, :svg, false)::Bool

  pngfile = "$name.png"
  svgfile = "$name.svg"

  # add the generated png name to the list of examples for this page, which
  # can later be used to assemble an overview page
  # for some reason franklin needs a pair as the content?
  pngsvec, _ = get!(Franklin.LOCAL_VARS, "examplefigures_png", String[] => Vector{String})
  push!(pngsvec, pngfile)

  middle, _ = split(middle, r"```\s*$")
  s = """
    ```julia:$name
    __result = begin # hide
    $middle
    end # hide
    save(joinpath(@OUTPUT, "$pngfile"), __result) # hide
    $(svg ? "save(joinpath(@OUTPUT, \"$svgfile\"), __result) # hide" : "")
    nothing # hide
    ```
    ~~~
    <a id="$name">
    ~~~
    \\fig{$name.$(svg ? "svg" : "png")}
    ~~~
    </a>
    ~~~
  """

  s
end


function lx_video(lxc, _)
    if length(lxc.braces) == 1
        rpath = Franklin.stent(lxc.braces[1])
        alt   = ""
    elseif length(lxc.braces) == 2
        rpath = Franklin.stent(lxc.braces[2])
        alt   = Franklin.stent(lxc.braces[1])
    end
    
    path  = Franklin.parse_rpath(rpath; canonical=false, code=true)
    fdir, fext = splitext(path)

    # there are several cases
    # A. a path with no extension --> guess extension
    # B. a path with extension --> use that
    # then in both cases there can be a relative path set but the user may mean
    # that it's in the subfolder /output/ (if generated by code) so should look
    # both in the relpath and if not found and if /output/ not already last dir
    candext = ifelse(isempty(fext),
                     (".mp4", ".mkv", ".mov"), (fext,))
    for ext ∈ candext
        candpath = fdir * ext
        syspath  = joinpath(Franklin.PATHS[:site], split(candpath, '/')...)
        isfile(syspath) && return html_video(candpath, alt)
    end
    # now try in the output dir just in case (provided we weren't already
    # looking there)
    p1, p2 = splitdir(fdir)
    if splitdir(p1)[2] != "output"
        for ext ∈ candext
            candpath = joinpath(p1, "output", p2 * ext)
            syspath  = joinpath(Franklin.PATHS[:site], split(candpath, '/')...)
            isfile(syspath) && return html_video(candpath, alt)
        end
    end
    return Franklin.html_err("Video matching '$path' not found.")
  end

function html_video(path, alt)
  """
  ~~~
  <video src="$path" controls="true" loop="true"></video>
  ~~~
  """
end


@delay function hfun_list_folder_with_images(params)

    file_location = locvar("fd_rpath")
    pathparts = split(file_location, r"\\|/")
    folder = joinpath(pathparts[1:end-1]..., only(params))

    mds = @chain begin
        readdir(joinpath(@__DIR__, folder))
        filter(endswith(".md"), _)
        filter(!=("index.md"), _)
    end


    divs = join(map(mds) do page
        name = splitext(page)[1]

        title = pagevar(joinpath(folder, page), "title")

        outputpath = joinpath(@__DIR__, "__site", "assets",
            folder, name, "code", "output")

        !isdir(outputpath) && return ""

        # retrieve the ordered list of generated pngs written by `env_examplefigure`
        pngpaths = pagevar(
          joinpath(folder, name),
          "examplefigures_png",
          default = String[]
        )

        filter!(pngpaths) do p
          if isfile(joinpath(outputpath, p))
            true
          else
            @warn "File $p from the list of example images for site \"$name\" was not found, it probably wasn't generated correctly."
            false
          end
        end

        thumb_height = 350

        thumbpaths = map(pngpaths) do p
          thumbpath = joinpath(outputpath, splitext(p)[1] * "_thumb.png")
          
          img = load(joinpath(outputpath, p))
          sz = size(img)
          # height is dim 1
          new_size = round.(Int, sz .÷ (sz[1] / thumb_height))
          img_resized = imresize(RGB{Float32}.(img), new_size,
            method=ImageTransformations.Interpolations.Lanczos4OpenCV())
          img_clamped = mapc.(x -> clamp(x, 0, 1), img_resized)
          save(thumbpath, img_clamped)

          thumbpath
        end

        thumbpaths_website = "/assets/$folder/$name/code/output/" .* basename.(thumbpaths)

        """
        
        <div class="plotting-functions-item">
          <a href="$name"><h2>$title</h2></a>
          <div class="plotting-functions-thumbcontainer">
            $(
                map(thumbpaths_website, pngpaths) do thumbpath, pngpath
                    bn = splitext(basename(pngpath))[1]
                    "<a href=\"$name#$bn\"><img class='plotting-function-thumb' src=\"$thumbpath\"/></a>"
                end |> join
            )
          </div>
        </div>
        """
    end)

    "<div class=\"plotting-functions-grid\">$divs</div>"
end


@delay function hfun_list_folder(params)

    file_location = locvar("fd_rpath")
    pathparts = split(file_location, r"\\|/")
    folder = joinpath(pathparts[1:end-1]..., only(params))

    mds = @chain begin
        readdir(joinpath(@__DIR__, folder))
        filter(endswith(".md"), _)
        filter(!=("index.md"), _)
    end

    titles = map(mds) do md
        p = joinpath(folder, md)
        t = pagevar(p, "title")::String
    end


    "<ul>" *
    join(map(mds, titles) do page, title
        name = splitext(page)[1]
        """<a href="$name"><li>$title</li></a>"""
    end) *
    "</ul>"
end


function hfun_colorschemes()

    md = IOBuffer()

    write(md, """
    <h2>misc</h2>
    <p>These colorschemes are not defined or provide different colors in ColorSchemes.jl
    They are kept for compatibility with the old behaviour of Makie, before v0.10.</p>
    """)
    write(
        md,
        generate_colorschemes_table(
            [:default; sort(collect(keys(PlotUtils.MISC_COLORSCHEMES)))]
        )
    )
    write(md, "<p>The following colorschemes are defined by ColorSchemes.jl.</p>")
    for cs in ["cmocean", "scientific", "matplotlib", "colorbrewer", "gnuplot", "colorcet", "seaborn", "general"]
        ks = sort([k for (k, v) in PlotUtils.ColorSchemes.colorschemes if occursin(cs, v.category)])
        write(md, "<h2>$cs</h2>")
        write(md, generate_colorschemes_table(ks))
    end

    String(take!(md))
end