# This file was generated, do not modify it. # hide
__result = begin # hide
  
using CairoMakie

scene, layout = layoutscene(resolution = (1200, 1200))

layout[1, 1] = Axis(scene, title="No grid layout")
layout[2, 1] = Axis(scene, title="No grid layout")
layout[3, 1] = Axis(scene, title="No grid layout")

subgl_1 = layout[1, 2] = GridLayout(alignmode=Inside())
subgl_2 = layout[2, 2] = GridLayout(alignmode=Outside())
subgl_3 = layout[3, 2] = GridLayout(alignmode=Outside(50))

subgl_1[1, 1] = Axis(scene, title="Inside")
subgl_2[1, 1] = Axis(scene, title="Outside")
subgl_3[1, 1] = Axis(scene, title="Outside(50)")

layout[1:3, 2] = [Box(scene, color = :transparent, strokecolor = :red) for i in 1:3]

scene

  end # hide
  save(joinpath(@OUTPUT, "example_16427511238910256679.png"), __result) # hide
  
  nothing # hide