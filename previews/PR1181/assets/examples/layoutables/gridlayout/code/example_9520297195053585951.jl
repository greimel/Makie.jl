# This file was generated, do not modify it. # hide
__result = begin # hide
  
using CairoMakie

scene, layout = layoutscene(resolution = (1200, 900))

layout[1, 1] = Axis(scene, title = "I'm square and aligned")
layout[1, 2] = Box(scene, color = (:blue, 0.1), strokecolor = :transparent)
layout[1, 2] = Axis(scene, aspect = AxisAspect(1),
    title = "I'm square but break the layout.\nMy actual cell is the blue rect.")
layout[2, 1] = Axis(scene)
layout[2, 2] = Axis(scene)

rowsize!(layout, 2, Relative(2/3))
colsize!(layout, 1, Aspect(1, 1))

scene

  end # hide
  save(joinpath(@OUTPUT, "example_9520297195053585951.png"), __result) # hide
  
  nothing # hide