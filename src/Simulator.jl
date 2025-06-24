
function analyse_population(p::Population{I}) where I<:SexualIndividual
    fits = fitness.(p)

    total_fitness_average = mean(fits)
    total_fitness_maximum = maximum(fits)

    (posInds, negInds) = separate_sex(p)
    sex_ratio = length(posInds) / length(p)

    posFits = fitness.(posInds)
    postiver_fitness_maximum = maximum(posFits)
    postiver_fitness_average = mean(posFits)

    negFits = fitness.(negInds)
    negativer_fitness_average = mean(negFits)
    negativer_fitness_maximum = maximum(negFits)

    return (
        total_fitness_average=total_fitness_average,
        total_fitness_maximum=total_fitness_maximum,
        sex_ratio=sex_ratio,
        postiver_fitness_average=postiver_fitness_average,
        postiver_fitness_maximum=postiver_fitness_maximum,
        negativer_fitness_average=negativer_fitness_average,
        negativer_fitness_maximum=negativer_fitness_maximum,
    )
end

function analyse_population(p::Population{I}) where I<:AsexualIndividual
    fits = fitness.(p)

    total_fitness_average = mean(fits)
    total_fitness_maximum = maximum(fits)

    return (
        total_fitness_average=total_fitness_average,
        total_fitness_maximum=total_fitness_maximum,
    )
end

function run_simulation(species::Species; amount::Int=200, press=0.2, epoch=10, seeds::SimulationSeeds=SimulationSeeds())
    rng = SimulationRNG(seeds)

    results = Any[]

    population = random_population(species, amount; indRNG=rng.indGen, sexRNG=rng.sex)
    push!(results, analyse_population(population))

    for i in 1:epoch
        population = evolution_pass(population, press; mateRNG=rng.matePointer, mutateRNG=rng.mutation, courtRNG=rng.courtship)
        push!(results, analyse_population(population))
    end

    return results
end