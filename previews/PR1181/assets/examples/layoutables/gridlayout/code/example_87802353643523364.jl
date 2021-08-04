# This file was generated, do not modify it. # hide
__result = begin # hide
  
using CairoMakie

scene, layout = layoutscene(4, 4, resolution = (1200, 1200))

layout[1, 1:2] = Axis(scene, title="[1, 1:2]")
layout[2:4, 1:2] = Axis(scene, title="[2:4, 1:2]")
layout[:, 3] = Axis(scene, title="[:, 3]")
layout[1:3, end] = Axis(scene, title="[1:3, end]")
layout[end, end] = Axis(scene, title="[end, end]")

scene

  end # hide
  save(joinpath(@OUTPUT, "example_87802353643523364.png"), __result) # hide
  
  nothing # hide