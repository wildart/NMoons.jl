using NMoons, Test

@testset "Moons" begin
    c = 2
    m = 100
    d = 2
    ε = 0.0
    rp = (0.5, 0.0)
    t = [5.0, 0.0]
    θ = Dict((1=>2) => π/2)

    @testset for r in [1.0, 2.0, 1.5]
        X, L = nmoons(Float64, m, c, ε=ε, d=d, r=r, repulse=rp, translation=t, rotations=θ)
        @test size(X) == (d, c*m)
        @test length(L) == c*m
        @test unique(L) == collect(1:c)
        @test X[1,1] ≈ t[1]
        @test X[2,1] ≈ -r atol=0.01
        @test X[1,m] ≈ t[1]
        @test X[2,m] ≈ -2*r*(1+rp[1]) atol=0.01
        @test X[1,m+1] ≈ t[1]
        @test X[2,m+1] ≈ r atol=0.01
        @test X[1,c*m] ≈ t[1]
        @test X[2,c*m] ≈ 2*r*(1+rp[1]) atol=0.01
    end

    c = 3
    d = 3
    rp = (0.25, 0.25)
    t = [0.0, 1.0, 0.0]
    @testset for r in [1.0, 2.0, 1.5]
        X, L = nmoons(Float64, m, c, ε=ε, d=d, r=r, repulse=rp, translation=t)
        @test size(X) == (d, c*m)
        @test length(L) == c*m
        @test unique(L) == collect(1:c)
        @test X[1,1] ≈ -r*rp[1]*2 atol=0.01
        @test X[2,1] ≈ t[2]+r*rp[2] atol=0.01
        @test X[3,1] ≈ 0.0
    end
end

@testset "Spheres" begin
    c = 1
    m = 300
    d = 2
    s = 1
    ε = 0.0
    t = [5.0, 0.0]
    θ = Dict((1=>2) => π/2)

    X, L = spheres(Float64, m, c, s=s, d=d, ε=ε, translation=t, rotations=θ)
    @test size(X) == (d, c*m)
    @test length(L) == c*m
    @test unique(L) == collect(1:c)
    @test X[1,1] ≈ t[1]
    @test X[2,1] ≈ 1.0
    @test X[1,m] ≈ t[1] atol = 0.1
    @test X[2,m] ≈ 1.0 atol = 0.1

    c = 2
    X, L = spheres(Float64, m, c, s=s, d=d, ε=ε, translation=t, rotations=θ)
    @test size(X) == (d, c*m)
    @test length(L) == c*m
    @test unique(L) == collect(1:c)
    @test X[1,1] ≈ t[1]
    @test X[2,1] ≈ 0.5
    @test X[1,m] ≈ t[1] atol = 0.1
    @test X[2,m] ≈ 0.5 atol = 0.1
    @test X[1,m+1] ≈ t[1]
    @test X[2,m+1] ≈ 1.0
    @test X[1,c*m] ≈ t[1] atol = 0.1
    @test X[2,c*m] ≈ 1.0 atol = 0.1

    c = 2
    d = 3
    s = 2
    t = [5.0, 0.0, 0.0]
    X, L = spheres(Float64, m, c, s=s, d=d, ε=ε, translation=t, rotations=θ)
    @test size(X) == (d, c*m)
    @test length(L) == c*m
    @test unique(L) == collect(1:c)
    @test X[1,1] ≈ t[1]
    @test X[2,1] ≈ 0.0 atol = 0.1
    @test X[3,1] ≈ 0.5 atol = 0.1
    @test X[1,m] ≈ t[1]
    @test X[2,m] ≈ 0.0 atol = 0.1
    @test X[3,m] ≈ -0.5 atol = 0.1
    @test X[1,c*m] ≈ 5.0 atol = 0.1
    @test X[2,c*m] ≈ 0.0 atol = 0.1
    @test X[3,c*m] ≈ -1.0 atol = 0.1

    d = 5
    t = [5.0, 0.0, 0.0, 0.0, 1.0]
    X, L = spheres(Float64, m, c, s=s, d=d, ε=ε, translation=t, rotations=θ)
    @test size(X) == (d, c*m)
    @test X[4,1] == 0.0
    @test X[5,1] == 1.0
end

@testset "Rotations" begin
    m = 100
    d = 5

    X = ones(d,m)
    θ = Dict((1=>2) => π/2, (2=>3) => π/2)
    NMoons.rotate!(X, θ)
    @test X[1:2,:] ≈ fill(-1.0,2,m)

    X = ones(d,m)
    θ = Dict((1=>1) => π)
    NMoons.rotate!(X, θ)
    @test length(findall(isequal(1.0), X[:,1])) >= 3

    X = ones(d,m)
    θ = Dict((0=>0) => π)
    NMoons.rotate!(X, θ)
    @test length(findall(isequal(1.0), X[:,1])) == 0

    X = ones(d,m)
    θ = Dict{Pair{Int,Int},Int}()
    NMoons.rotate!(X, θ)
    @test X == ones(d,m)
end
