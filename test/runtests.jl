using Recommendation
using Base.Test

# write your own tests here
@test 1 == 1

include("recommender.jl")

include("baseline.jl")

include("utils/measures.jl")
