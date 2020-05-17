using NMoons, Test

@testset "Moons" begin
    c = 2
    m = 100
    d = 2
    ε = 0.0
    r = 2.0
    rp = (1.0, 0.0)
    t = [5.0, 0.0]
    θ = Dict((1=>2) => π/2)

    X, L = nmoons(Float64, m, c, ε=ε, d=d, r=r, repulse=rp, translation=t, rotations=θ)
    @test size(X) == (d, c*m)
    @test length(L) == c*m
    @test unique(L) == collect(1:c)
    @test X[1,1] ≈ t[1]
    @test X[2,1] ≈ -rp[1]*r
    @test X[1,m] ≈ t[1]
    @test X[2,m] ≈ -t[1]*r-r
    @test X[1,m+1] ≈ t[1]
    @test X[2,m+1] ≈ t[1]*r
    @test X[1,c*m] ≈ t[1]
    @test X[2,c*m] ≈ t[1]*r+r

    c = 3
    d = 3
    rp = (0.25, 0.25)
    t = [0.0, 1.0, 0.0]
    X, L = nmoons(Float64, m, c, ε=ε, d=d, r=r, repulse=rp, translation=t)
    @test size(X) == (d, c*m)
    @test length(L) == c*m
    @test unique(L) == collect(1:c)
    @test X[3,1] ≈ 0.0
    @test X[1,1] ≈ -r*rp[1]
    @test X[2,1] ≈ t[2]
end

@testset "Spheres" begin

end
