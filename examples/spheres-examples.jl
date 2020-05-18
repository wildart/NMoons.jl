using NMoons, Plots

X, L = spheres(Float64, 100, 2, ε=0, d=2, s=1)
scatter(X[1,:], X[2,:], markersize=1.0, legend=:none, color=L)

X, L = spheres(Float64, 100, 2, ε=0.05, d=2, translation=[0.25, 0.0])
scatter(X[1,:], X[2,:], markersize=1.0, legend=:none, color=L)

X, L = spheres(Float64, 100, 3, ε=0, d=2, translation=[-0.25, -0.25])
scatter(X[1,:], X[2,:], markersize=1.0, legend=:none, color=L)

X, L = spheres(Float64, 100, 2, ε=0.3, d=10, rotations=Dict((1=>3)=>π/3, (2=>4)=>-π/4))
scatter(X[1,:], X[2,:], markersize=1.0, legend=:none, color=L)

X, L = spheres(Float64, 100, 2, ε=0.0, d=3, s=2, translation=[0.5;0;0])
scatter3d(X[1,:], X[2,:], X[3,:], markersize=1.0, legend=:none, color=L, zlim=[-1,1])

X, _ = spheres(Float64, 100, 3, ε=0.0, d=3, s=2,
              translation=[0.5;0;0], rotations=Dict((1=>3)=>π/2, (1=>2)=>-π/2))
scatter3d(X[1,:], X[2,:], X[3,:], markersize=1.0, legend=:none, color=:black, zlim=[-1,1], xlim=[-1,1], ylim=[-1,1])
