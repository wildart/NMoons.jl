module NMoons

using Random

export nmoons, spheres

rotate2d(θ) = [cos(θ) -sin(θ); sin(θ) cos(θ)]

include("nmoons.jl")
include("spheres.jl")

end
