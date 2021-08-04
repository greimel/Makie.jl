# This file was generated, do not modify it. # hide
__result = begin # hide
  
using CairoMakie

f = Figure(resolution = (1200, 1200))

Axis(f[1, 1], title = "Shrunk")
Axis(f[2, 1], title = "Expanded")
Label(f[1, 2], "tellheight = true", tellheight = true)
Label(f[2, 2], "tellheight = false", tellheight = false)

f

  end # hide
  save(joinpath(@OUTPUT, "example_6010117918054217813.png"), __result) # hide
  
  nothing # hide