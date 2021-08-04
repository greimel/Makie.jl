# This file was generated, do not modify it. # hide
__result = begin # hide
  
using CairoMakie

scene, layout = layoutscene(resolution = (1200, 900))

layout[1, 1] = Axis(scene, title = "My column infers my width\nof 200 units")
layout[1, 2] = Axis(scene, title = "My column gets 1/3rd\nof the remaining space")
layout[1, 3] = Axis(scene, title = "My column gets 2/3rds\nof the remaining space")

colsize!(layout, 2, Auto(1)) # equivalent to Auto(true, 1)
colsize!(layout, 3, Auto(2)) # equivalent to Auto(true, 2)

scene

  end # hide
  save(joinpath(@OUTPUT, "example_85609092639623926.png"), __result) # hide
  
  nothing # hide