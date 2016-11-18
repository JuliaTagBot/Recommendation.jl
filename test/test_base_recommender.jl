immutable Foo <: Recommender
    da::DataAccessor
end

function test_not_implemented_error()
    println("-- Testing recommender not implemented case")
    da = DataAccessor(sparse([1 2 3; 4 5 6]))
    recommender = Foo(da)
    @test_throws ErrorException build(recommender)
    @test_throws ErrorException predict(recommender, 1, 1)
    @test_throws ErrorException ranking(recommender, 1, 1)
end

function test_execute()
    println("-- Testing recommender execution")

    # non-personalized (MostPopular) recommendation for 3 items
    da = DataAccessor(sparse([1 0 0; 4 5 0]))
    recommender = MostPopular(da)
    build(recommender)
    pairs = execute(recommender, 1, 3, [:item1, :item2, :item3])

    @test first(pairs[1]) == :item1
    @test last(pairs[1]) == 2
    @test first(pairs[2]) == :item2
    @test last(pairs[2]) == 1
    @test first(pairs[3]) == :item3
    @test last(pairs[3]) == 0
end

test_not_implemented_error()
test_execute()