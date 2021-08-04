# This file was generated, do not modify it. # hide
__result = begin # hide
  
using CairoMakie

scene, layout = layoutscene(resolution = (1200, 900))

ax1 = layout[1, 1] = Axis(scene, title = "Axis 1")
ax2 = layout[1, 2] = Axis(scene, title = "Axis 2")

scene

  end # hide
  save(joinpath(@OUTPUT, "example_1480690751776636558.png"), __result) # hide
  
  nothing # hide