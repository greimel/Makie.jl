# This file was generated, do not modify it. # hide
__result = begin # hide
  
using CairoMakie

scene, layout = layoutscene(resolution = (1200, 900))

layout[1, 1] = Axis(scene, title = "My column has size Relative(2/3)")
layout[1, 2] = Axis(scene, title = "My column has size Auto()")
layout[1, 3] = Colorbar(scene)

colsize!(layout, 1, Relative(2/3))

scene

  end # hide
  save(joinpath(@OUTPUT, "example_10393269468854575184.png"), __result) # hide
  
  nothing # hide