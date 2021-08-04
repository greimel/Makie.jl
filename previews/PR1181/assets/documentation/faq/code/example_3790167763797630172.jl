# This file was generated, do not modify it. # hide
__result = begin # hide
  
using CairoMakie
CairoMakie.activate!() # hide

f = Figure(resolution = (1200, 1200))

ax1 = Axis(f, title = "Squashed")
ax2 = Axis(f[1, 1], title = "Placed in Layout")
ax3 = Axis(f, bbox = BBox(400, 800, 400, 800),
  title = "Placed at BBox(400, 800, 400, 800)")

f

  end # hide
  save(joinpath(@OUTPUT, "example_3790167763797630172.png"), __result) # hide
  
  nothing # hide