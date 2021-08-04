# This file was generated, do not modify it. # hide
__result = begin # hide
  
using CairoMakie

scene, layout = layoutscene(resolution = (1200, 900))

layout[1, 1] = Axis(scene, title = "My column has size Fixed(400)")
layout[1, 2] = Axis(scene, title = "My column has size Auto()")

colsize!(layout, 1, Fixed(400))
# colsize!(layout, 1, 400) would also work

scene

  end # hide
  save(joinpath(@OUTPUT, "example_2630845883682622478.png"), __result) # hide
  
  nothing # hide