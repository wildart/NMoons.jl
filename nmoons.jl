using Random

"""
    nmoons(T, n, c) -> (Matrix{T}, Vector{Int})

Generate a half-moon dataset.

Parameters:
- `T`: data type for points' coordinates
- `n`: number of samples in the resulting dataset
- `c`: number of half-circle subsets in the generated dataset

Keyword parameters:
- `ε`: variance of a random Gaussian noise
- `d`: dimension of the full space
- `translation`: half-circle subsets translation parameters (must be of size `d`)
- `rotations`: dataset rotation parameters. Each rotation is specified as angle between particular pair of axis
- `shuffle`: perform point shuffling in the dataset, default value `true`
- `seed`: RNG seed value (if it's `nothing` then RNG will not be initialized), default value `nothing`

Here is an example of dataset generation:
```jldoctest
julia> X, L = nmoons(Float64, 100, 2,        # Generate 100 Float64 points divided on two susbsets
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
function nmoons(::Type{T}, n::Int=100, c::Int=2;
                shuffle::Bool=false, ε::Real=0.1, d::Int = 2,
                translation::Vector{T}=zeros(T, d),
                rotations::Dict{Pair{Int,Int},T} = Dict{Pair{Int,Int},T}(),
                seed::Union{Int,Nothing}=nothing) where {T <: Real}
    rng = seed === nothing ? Random.GLOBAL_RNG : MersenneTwister(Int(seed))
    ssize = floor(Int, n/c)
    ssizes = fill(ssize, c)
    ssizes[end] += n - ssize*c
    @assert sum(ssizes) == n "Incorrect partitioning"
    pi = convert(T, π)
    R(θ) = [cos(θ) -sin(θ); sin(θ) cos(θ)]
    X = zeros(d,0)
    for (i, s) in enumerate(ssizes)
        circ_x = cos.(range(zero(T), pi, length=s)).-1.0
        circ_y = sin.(range(zero(T), pi, length=s))
        C = R(-(i-1)*(2*pi/c)) * hcat(circ_x, circ_y)'
        C = vcat(C, zeros(d-2, s))
        dir = zeros(d)-C[:,end] # translation direction
        #dir ./= abs(sum(dir))
        @debug "Dimension $i"  direction=dir
        X = hcat(X, C .+ dir.*translation)
    end
    y = vcat([fill(i,s) for (i,s) in enumerate(ssizes)]...)
    if shuffle
        idx = randperm(rng, n)
        X, y = X[:, idx], y[idx]
    end
    # Add noise to the dataset
    if ε > 0.0
        #using Distributions
        #Nz = Normal(zero(T), convert(T,ε/d))
        #X += rand(rng, Nz, size(X))
        X += randn(rng, size(X)).*convert(T,ε/d)
    end
    # Rotate dataset
    for ((i,j),θ) in rotations
        X[[i,j],:] .= R(θ)*view(X,[i,j],:)
    end
    return X, y
end
