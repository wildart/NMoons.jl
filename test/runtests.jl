using NMoons, Test

@testset "Moons" begin
    c = 2
    m = 100
    d = 2
    ε = 0.0
    r = 2.0
    t = [5.0, 0.0]
    θ = Dict((1=>2) => π/2)

    X, L = nmoons(Float64, m, c, ε=ε, d=d, r=r, translation=t, rotations=θ)
    @test size(X) == (d, c*m)
    @test length(L) == c*m
    @test unique(L) == collect(1:c)
    @test X[2,1] ≈ -t[1]*r
    @test X[2,m] ≈ -t[1]*r-r
    @test X[2,m+1] ≈ t[1]*r
    @test X[2,c*m] ≈ t[1]*r+r
end
