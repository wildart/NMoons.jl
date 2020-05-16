using NMoons, Test

@testset "Moons" begin
    c = 2
    m = 100
    d = 2
    ε = 0.0
    t = [10.0, 0.0]
    θ = [0.0, 0.0]

    X, L = nmoons(Float64, m, c, ε=ε, d=d, translation=t)
    @test size(X) == (d, c*m)
    @test length(L) == c*m
    @test unique(L) == collect(1:c)
end
