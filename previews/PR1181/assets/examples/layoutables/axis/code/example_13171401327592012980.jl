# This file was generated, do not modify it. # hide
__result = begin # hide
  
using CairoMakie

scene, layout = layoutscene(resolution = (1400, 900))
ax1 = layout[1, 1] = Axis(scene, title = "vlines")

lines!(ax1, 0..4pi, sin)
vlines!(ax1, [pi, 2pi, 3pi], color = :red)

ax2 = layout[1, 2] = Axis(scene, title = "hlines")
hlines!(ax2, [1, 2, 3, 4], xmax = [0.25, 0.5, 0.75, 1], color = :blue)

scene

  end # hide
  save(joinpath(@OUTPUT, "example_13171401327592012980.png"), __result) # hide
  
  nothing # hide