# This file was generated, do not modify it. # hide
__result = begin # hide
  
using GLMakie
using FileIO
GLMakie.activate!() # hide
Makie.inline!(true) # hide

f = Figure(resolution = (1000, 1000), fontsize = 10)

brain = load(assetpath("brain.stl"))
colors = [tri[1][2] for tri in brain for i in 1:3]

azimuths = LinRange(0, 2pi, 8)[1:7]
elevations = LinRange(-pi/2 + 0.01, pi/2 - 0.01, 8)[1:7]

for (i, elevation) in enumerate(elevations)
    for (j, azimuth) in enumerate(azimuths)
        ax = Axis3(f[i, j], aspect = :data,
        title = "elevation = $(round(elevation/pi, digits = 2))π\nazimuth = $(round(azimuth/pi, digits = 2))π",
        elevation = elevation, azimuth = azimuth,
        protrusions = (0, 0, 0, 20))

        hidedecorations!(ax)
        mesh!(brain, color = colors, colormap = :thermal)
    end
end

f

  end # hide
  save(joinpath(@OUTPUT, "example_11925788351545684107.png"), __result) # hide
  
  nothing # hide