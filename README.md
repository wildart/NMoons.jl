# "N-Moons" Dataset Generator

## Description

The original "Two Moons" (TM) dataset contains two interleaving clusters of 2D points shaped as half-circles with radii 1.0 with an added Gaussian noise.

This the data generation procedure provides a family of generated datasets that contain an arbitrary number of half-circles with points located in an arbitrary dimensional space. Following parameters used to generate a dataset:

- Number of the half-circle structures, `c`
- Number of data points per structure, `m`
- Number of dimensions, `d`
- Variance of a random Gaussian noise `ε` added to the point coordinate to shift it from its original location
- Repulsion magnitudes, `repulse`, for moving half-circle structures away from each other
- Translation vector, `translate`, for the whole dataset
- Dataset rotation parameters, `θ`
- Random generator seed value, `seed`

A half-circle is a one dimensional structure in the two dimensional space.
We can generate multiple point subsets for each half-circles structure from
the origin point arranged in circular way, rotated in a clockwise direction.

In addition, we specify how far the half-circle subsets move from the origin
by providing a repulsion magnitude which determines how far the subsets are
translated in the direction away from the origin towards the farthest point in
the subset. By default, the farthest point is located at the diameter length
from the origin, the first point. We define repulsion parameters for
each dimension of the two dimensional collection of the half-circles.

For example, the original TM dataset has half-circle subsets moved
away from each other along the `x`-axis at the radius length.
Using repulsion magnitudes with values `(0.5, 0.0)`, we simultaneously move both
subsets away from each other on distance of the half of the radius of
half-circle, `r/2`, which results in total translation of half-circle subsets
against each other at the distance of one radius on $x$-axis.

For testing algorithms' properties in high dimensions, we create
zero points in $d$-dimensional space, and add coordinates of the half-circle
structure 2D representation to specified dimensions of the generated points,
resulting in the creation of the structure embedded in the higher dimensional
space beyond the dimension 2.

After half-circle subsets generated, a Gaussian noise is added to each point coordinate.
In order to limit the noise variance in high dimensions, we scale the Gaussian
noise variance proportionally to the number of the space dimensions, `σ^2 = ε/d`.

To compensate for padded zero coordinates in high dimensional space
setup, we allow to perform arbitrary rotations of the generated dataset.
The generation procedure accepts a set of rotation angles between specified
coordinate axis which is used to rotate completely generated dataset.
Moreover, we provide a translation vector that moves the whole dataset to
the specified translation coordinates. The dimension of the translation vector
is the same as the space dimension.

Along with the points, the generation procedure provides a class
assignment information related to a particular half-circle index and annotates
corresponding points with this index.

## Requirement

- Julia v1.1+

## Installation

Add [BoffinStuff](https://github.com/wildart/BoffinStuff.git) registry into the Julia package manager, and proceed with installation as follows:

```
pkg> registry add https://github.com/wildart/BoffinStuff.git
pkg> add NMoons
```

## Example

```julia
julia> using NMoons, Plots

julia> X, _ = nmoons(Float64, 100, 3, ε=0.3, d=2, repulse=(-0.25, -0.25))
([-0.533454 -0.827157 … 1.28141 1.06369; -0.135382 0.214103 … -2.35917 -2.3159], [1, 1, 1, 1, 1, 1, 1, 1, 1, 1  …  3, 3, 3, 3, 3, 3, 3, 3, 3, 3])

julia> scatter(X[1,:], X[2,:], markersize=1.0, legend=:none, color=:black)
```
