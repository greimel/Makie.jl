# This file was generated, do not modify it. # hide
__result = begin # hide
  
using CairoMakie

scene, layout = layoutscene(30, resolution = (1200, 900))

subgl_left = GridLayout()
subgl_left[1:2, 1:2] = [Axis(scene) for i in 1:2, j in 1:2]

subgl_right = GridLayout()
subgl_right[1:3, 1] = [Axis(scene) for i in 1:3]

layout[1, 1] = subgl_left
layout[1, 2] = subgl_right

scene

  end # hide
  save(joinpath(@OUTPUT, "example_1600585324001295073.png"), __result) # hide
  
  nothing # hide