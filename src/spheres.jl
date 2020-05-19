"""
    spheres(T, m, c; kwargs...) -> (Matrix{T}, Vector{Int})

Generate a spheres dataset.

Parameters:
- `T`: data type for points' coordinates
- `m`: number of samples in the subset
- `c`: number of concentric sphere subsets in the generated dataset

Keyword parameters:
- `s`: dimension of the shpere, default 1
- `ε`: variance of a random Gaussian noise, default 0.1
- `d`: dimension of the full space, default 2
- `r`: spheres' radii (must be of size `c`). If it's `nothing` then spheres are set apart with the same distance from each other.
- `translation`: translation vector
- `rotations`: dataset rotation parameters. Each rotation is specified as angle between particular pair of axis
- `shuffle`: perform point shuffling in the dataset, default value `true`
- `seed`: RNG seed value (if it's `nothing` then RNG will not be initialized), default value `nothing`

Here is an example of dataset generation:
```jldoctest
julia> X, L = spheres(Float64, 100, 2,        # Generate 100 Float64 points divided on two susbsets
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
function spheres(::Type{T}, m::Int=100, c::Int=2; s=1,
                 shuffle::Bool=false, ε::Real=0.1, d::Int = 2,
                 r::Union{Vector{T},Nothing}=nothing,
                 translation::Vector{T}=fill(zero(T),d),
                 arrange::Tuple{T,T}=(zero(T),zero(T)),
                 rotations::Dict{Pair{Int,Int},T} = Dict{Pair{Int,Int},T}(),
                 seed::Union{Integer,Nothing}=nothing) where {T <: Real}
    @assert d > 1 "Ambient dimention must be grater than 1"
    @assert s < d "Sphere dimension cannot be large then the ambient space dimension"

    rng = seed === nothing ? Random.GLOBAL_RNG : MersenneTwister(seed)

    # setup subsets' sizes
    n = c*m
    ssizes = fill(m, c)
    ssizes[end] += n - m*c
    @assert sum(ssizes) == n "Incorrect partitioning"

    # setup radii
    radii = if r !== nothing
        r
    else
        radii = collect(range(zero(T), one(T), step=1/c))
        radii[2:end]
    end
    @assert length(radii) == c "Sphere dimension cannot be large then the ambient space dimension"

    pi = convert(T, π)
    ϕ = (sqrt(5.0) + 1.0) / 2.0  # golden ratio = 1.618033988749895
    g = (2.0 - ϕ) * (2.0*pi)    # golden angle = 2.399963229728653

    X = zeros(d,0)
    for (i, sz) in enumerate(ssizes)
        C = if s == 1 # Circle
            pts = range(zero(T), 2 * pi, length=sz+1)[1:end-1]
            circ_x = cos.(pts) * convert(T, radii[i])
            circ_y = sin.(pts) * convert(T, radii[i])
            hcat(circ_x, circ_y, zeros(sz, d-2)) # pad dimensions with 0s
        else # Sphere
            lon = 1 .- (2i/sz for i in 1:sz)
            rr = sqrt.(1 .- lon.^2) .* convert(T, radii[i])
            sphr_x = rr .* cos.( g*i for i in 0:sz-1 )
            sphr_y = rr .* sin.( g*i for i in 0:sz-1 )
            sphr_z = lon .* convert(T, radii[i])
            hcat(sphr_x, sphr_y, sphr_z, zeros(sz, d-3))
        end
        X = hcat(X, C')
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
        X[[i,j],:] .= rotate2d(θ)*view(X,[i,j],:)
    end
    # translate dataset
    X .+= translation
    return X, y
end
