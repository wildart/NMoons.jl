using Random

"""
    nmoons(T, n, c; kwargs...) -> (Matrix{T}, Vector{Int})

Generate a half-moon dataset.

Parameters:
- `T`: data type for points' coordinates
- `m`: number of samples per structure
- `c`: number of half-circle subsets in the generated dataset

Keyword parameters:
- `d`: dimension of the full space
- `r`: radius of the half-circle
- `ε`: variance of a random Gaussian noise
- `translation::Vector{T}`: half-circle subsets translation parameters (must be of size `d`)
- `rotations::Dict{Pair{Int,Int},T}`: dataset rotation parameters. Each rotation is specified as angle between particular pair of axes
- `shuffle`: perform point shuffling in the dataset, default value `true`
- `seed`: RNG seed value (if it's `nothing` then RNG will not be initialized), default value `nothing`

Here is an example of dataset generation:
```jldoctest
julia> X, L = nmoons(Float64, 100, 2,        # Generate 200 Float64 points divided on two susbsets
                     ε=0.0, d=3,             # in 3D space with no noise
                     translation=[0.25;0;0], # translated from origin
                     rotations=Dict((1=>3)=>π/3, (1=>2)=>-π/3)); # rotated 30° from X to Z, -30° from X to Y

julia> X
3×100 Array{Float64,2}:
 0.125      0.179973   0.233692  …   0.262203   0.319      0.375
-0.216506  -0.183582  -0.149013     -0.709903  -0.680664  -0.649519
 0.433013   0.431233   0.425903      1.29193    1.29726    1.29904
```
"""
function nmoons(::Type{T}, m::Int=100, c::Int=2;
                shuffle::Bool=false, ε::Real=0.1, d::Int = 2, r::Real=1.0,
                translation::Vector{T}=zeros(T, d),
                rotations::Dict{Pair{Int,Int},T} = Dict{Pair{Int,Int},T}(),
                seed::Union{Int,Nothing}=nothing) where {T <: Real}
    rng = seed === nothing ? Random.GLOBAL_RNG : MersenneTwister(Int(seed))
    n = c*m
    ssize = floor(Int, m)
    ssizes = fill(ssize, c)
    ssizes[end] += n - ssize*c
    @assert sum(ssizes) == n "Incorrect partitioning"
    pi = convert(T, π)
    R(θ) = [cos(θ) -sin(θ); sin(θ) cos(θ)]
    X = zeros(d,0)
    for (i, s) in enumerate(ssizes)
        pts = range(zero(T), pi, length=s)
        circ_x = cos.(pts).-1.0
        circ_y = sin.(pts)
        C = R(-(i-1)*(2*pi/c)) * hcat(circ_x, circ_y)'
        C = vcat(C, zeros(d-2, s))
        dir = C[:,end]-zeros(d) # translation direction
        dir ./= abs(sum(dir))   # normalize directions
        @debug "Dimension $i"  dir="$dir" farthest="$(C[:,end])"
        translate = dir.*r.*translation
        @debug "Translation $i"  translate="$translate"
        X = hcat(X, C .+ translate)
    end
    # generate labels
    y = vcat([fill(i,s) for (i,s) in enumerate(ssizes)]...)
    # shuffle points
    if shuffle
        idx = randperm(rng, n)
        X, y = X[:, idx], y[idx]
    end
    # add noise to the dataset
    if ε > 0.0
        X += randn(rng, size(X)).*convert(T,ε/d)
    end
    # rotate dataset
    for ((i,j),θ) in rotations
        X[[i,j],:] .= R(θ)*view(X,[i,j],:)
    end
    return X, y
end
