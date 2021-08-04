# This file was generated, do not modify it. # hide
__result = begin # hide
  
using CairoMakie

scene, layout = layoutscene(resolution = (1200, 1200))

layout[1, 1] = Axis(scene)
for i in 1:3
    layout[:, end+1] = Axis(scene)
    layout[end+1, :] = Axis(scene)
end

layout[0, :] = Label(scene, text="Super Title", textsize=50)
layout[end+1, :] = Label(scene, text="Sub Title", textsize=50)
layout[2:end-1, 0] = Label(scene, text="Left Text", textsize=50,
    rotation=pi/2)
layout[2:end-1, end+1] = Label(scene, text="Right Text", textsize=50,
    rotation=-pi/2)

scene

  end # hide
  save(joinpath(@OUTPUT, "example_15288695648101333679.png"), __result) # hide
  
  nothing # hide