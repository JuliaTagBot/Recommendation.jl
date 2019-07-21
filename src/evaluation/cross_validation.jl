export cross_validation

"""
    cross_validation(
        n_fold::Int,
        metric::Type{<:Metric},
        k::Int,
        recommender_type::Type{<:Recommender},
        da::DataAccessor,
        recommender_args...
    )

Conduct `n_fold` cross validation for a combination of recommender `recommender_type` and metric `metric`. A recommender is initialized with `recommender_args`. For ranking metric, accuracy is measured by top-`k` recommendation.
"""
function cross_validation(n_fold::Int, metric::Type{<:Metric}, k::Int, recommender_type::Type{<:Recommender}, da::DataAccessor, recommender_args...)

    n_user, n_item = size(da.R)

    events = shuffle(da.events)
    n_events = length(events)

    step = convert(Int, round(n_events / n_fold))
    accum = 0.0

    for head in 1:step:n_events
        tail = min(head + step - 1, n_events)

        truth_events = events[head:tail]
        truth_da = DataAccessor(truth_events, n_user, n_item)

        train_events = vcat(events[1:head - 1], events[tail + 1:end])
        train_da = DataAccessor(train_events, n_user, n_item)

        # get recommender from the specified data type
        recommender = recommender_type(train_da, recommender_args...)
        build!(recommender)

        accum += evaluate(recommender, truth_da, metric(), k)
    end

    accum / n_fold
end
