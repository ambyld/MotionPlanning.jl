export PointRobot2D

# ---------- Point Robot ----------

type PointRobot2D <: SweptCollisionChecker
    obstacles::Shape2D      # pretty much always Compound2D
    count::Int
end
PointRobot2D(obstacles) = PointRobot2D(obstacles, 0)

is_free_state(v::Vec{2}, CC::PointRobot2D) = !colliding(v, CC.obstacles)
is_free_state(v::AbstractVector, CC::PointRobot2D) = !colliding(Vec(v[1],v[2]), CC.obstacles)
is_free_motion(v::Vec{2}, w::Vec{2}, CC::PointRobot2D) = (CC.count += 1; !colliding_ends_free(Line(v,w), CC.obstacles))
is_free_motion(v::AbstractVector, w::AbstractVector, CC::PointRobot2D) =
    (CC.count += 1; !colliding_ends_free(Line(Vec(v[1],v[2]), Vec(w[1],w[2])), CC.obstacles))
function is_free_path(path::Path, CC::PointRobot2D)
    for i in 1:length(path)-1
        !is_free_motion(path[i], path[i+1], CC) && return false
    end
    true
end
inflate(CC::PointRobot2D, eps; roundcorners = true) = eps > 0 ? PointRobot2D(inflate(CC.obstacles, eps, roundcorners = roundcorners)) : CC
addobstacle(CC::PointRobot2D, o::Shape2D) = PointRobot2D(Compound2D(CC.obstacles, o))
addblocker(CC::PointRobot2D, p::AbstractVector, r) = addobstacle(CC, Circle(p, r))
closest(p::Vec{2}, CC::PointRobot2D, W::AbstractMatrix) = closest(p, CC.obstacles, W)
closest(p::AbstractVector, CC::PointRobot2D, W::AbstractMatrix) = closest(Vec(p[1],p[2]), CC.obstacles, W)
close(p::Vec{2}, CC::PointRobot2D, W::AbstractMatrix, r2) = close(p, CC.obstacles, W, r2)
function close{T}(p::AbstractVector{T}, CC::PointRobot2D, W::AbstractMatrix, r2)
    cps = close(Vec(p[1],p[2]), CC.obstacles, W, r2)
    (T, Vector{T})[(d2, full(v)) for (d2, v) in cps]
end
plot(CC::PointRobot2D, lo = zeros(2), hi = ones(2); kwargs...) = plot(CC.obstacles, color = "red", edgecolor = "none",
                                                                      xmin = lo[1], xmax = hi[1], ymin = lo[2], ymax = hi[2]; kwargs...)
composable(CC::PointRobot2D, opts = (stroke("black"),)) = composable(CC.obstacles, opts)