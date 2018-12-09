export CollisionChecker, DiscreteCollisionChecker, SweptCollisionChecker
export is_free_state, is_free_motion, is_free_path, inflate, addobstacle, addblocker, close, closest

abstract type CollisionChecker end
abstract type DiscreteCollisionChecker <: CollisionChecker end
abstract type SweptCollisionChecker <: CollisionChecker end

include("collisioncheckers/SAT2D.jl")
include("collisioncheckers/robots2D.jl")
include("collisioncheckers/bvls.jl")
include("collisioncheckers/boxesND.jl")