using NMoons, Plots

X, _ = nmoons(Float64, 100, 2, ε=0, d=2, translation=[0., 0.0])
scatter(X[1,:], X[2,:], markersize=1.0, legend=:none, color=:black)

X, _ = nmoons(Float64, 100, 2, ε=0.05, d=2, translation=[5., 0.0])
scatter(X[1,:], X[2,:], markersize=1.0, legend=:none, color=:black)

X, _ = nmoons(Float64, 100, 3, ε=0, d=2, translation=[0., 0.0])
scatter(X[1,:], X[2,:], markersize=1.0, legend=:none, color=:black)

X, _ = nmoons(Float64, 100, 3, ε=0, d=2, translation=[-0.25, -0.25])
scatter(X[1,:], X[2,:], markersize=1.0, legend=:none, color=:black)

X, _ = nmoons(Float64, 100, 2, ε=0.3, d=10, translation=[0.25; zeros(9)])
scatter(X[1,:], X[2,:], markersize=1.0, legend=:none, color=:black)

scatter3d(X[1,:], X[2,:], X[3,:], markersize=1.0, legend=:none, color=:black, zlim=[-1,1])

X, _ = nmoons(Float64, 100, 2, ε=0.0, d=3, translation=[0.5;0;0])
scatter3d(X[1,:], X[2,:], X[3,:], markersize=1.0, legend=:none, color=:black, zlim=[-1,1])

X, _ = nmoons(Float64, 100, 2, ε=0.0, d=3,
              translation=[0.5;0;0], rotations=Dict((1=>3)=>π/2, (1=>2)=>-π/2))
scatter3d(X[1,:], X[2,:], X[3,:], markersize=1.0, legend=:none, color=:black, zlim=[-1,1], xlim=[-1,1], ylim=[-1,1])

using Logging
lgr = Logging.ConsoleLogger(stderr, Base.CoreLogging.Debug)
X, _ = with_logger(lgr) do
    nmoons(Float64, 100, 2, ε=0.00, d=2, r=2, translation=[0.5, 0.0], rotations=Dict((1=>2) => π/2))
end
scatter(X[1,:], X[2,:], ms=1.0, legend=:none, c=:black)
