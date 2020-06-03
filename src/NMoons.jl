module NMoons

using Random, Combinatorics

export nmoons, spheres

rotate2d(θ) = [cos(θ) -sin(θ); sin(θ) cos(θ)]

function rotate!(X, rotations)
    d = size(X,1)
    # form random rotations
    drot = [ds for ds in keys(rotations) if ds.first == ds.second]
    if length(drot)>0
        p = first(drot)
        θ = rotations[p]
        rotations = if p.first > 0
            dims = ((i,j) for i in 1:d, j in 1:d if i != j) |> collect
            [(shuffle!(dims); first(dims)) => rand()*θ for i in 1:p.first]
        else
            dims = collect(1:d)
            [tuple(p...) => rand()*θ for p in combinations(dims,2)]
        end
    end
    # rotate dataset
    for ((i,j),θ) in rotations
        v = view(X, [i, j], :)
        v .= rotate2d(θ)*v
    end
end

include("nmoons.jl")
include("spheres.jl")

end
