
function fitness(ind::Individual)
    return count(ind.genome) / length(ind.genome)
end

function separate_sex(individuals::AbstractArray{I}) where I<:SexualIndividual
    posInds = I[]
    negInds = I[]

    map(individuals) do ind
        ind.sex ? push!(posInds, ind) : push!(negInds, ind)
    end

    return (posInds=posInds, negInds=negInds)
end

function eliminate(p::AbstractArray{I}, selectivity::Real) where I
    amount = length(p)
    threshold = floor(Int, amount * selectivity)
    survivors = sort(p; by=fitness)[threshold+1:end]
    return (survivors=survivors, threshold=threshold)
end

function evolution_pass(p::Population{I}, selectivity::Real; mateRNG::AbstractRNG=Random.GLOBAL_RNG, mutateRNG::AbstractRNG=Random.GLOBAL_RNG, courtRNG::AbstractRNG=Random.GLOBAL_RNG) where I
    survivors, threshold = eliminate(p, selectivity)
    post_population = vcat(survivors, crossover_from(survivors, threshold; mateRNG=mateRNG, mutateRNG=mutateRNG, courtRNG=courtRNG))
    return Population(post_population)
end

