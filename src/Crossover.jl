function crossover(parent1::AsexualIndividual{N,S}, parent2::AsexualIndividual{N,S}; mateRNG::AbstractRNG=Random.GLOBAL_RNG, mutateRNG::AbstractRNG=Random.GLOBAL_RNG) where {N,S<:AsexualSpecies{N}}
    species = parent1.species
    point = rand(mateRNG, 1:N)

    child_genome = vcat(parent1.genome[1:point], parent2.genome[point+1:end])
    new_genome = xor.(child_genome, rand(mutateRNG, length(child_genome)) .<= species.mutation_rate)

    return AsexualIndividual{N,S}(new_genome, species)
end

function crossover(parent1::SexualIndividual{N,S}, parent2::SexualIndividual{N,S}; sex_check::Bool=true, mateRNG::AbstractRNG=Random.GLOBAL_RNG, mutateRNG::AbstractRNG=Random.GLOBAL_RNG, sexRNG::AbstractRNG=Random.GLOBAL_RNG) where {N,S<:SexualSpecies{N}}
    parent1.sex != parent2.sex ? nothing : throw(error("homosexual could not mating"))

    species = parent1.species
    point = rand(mateRNG, 1:N)

    child_genome = vcat(parent1.genome[1:point], parent2.genome[point+1:end])
    new_genome = xor.(child_genome, rand(mutateRNG, length(child_genome)) .<= species.mutation_rate)

    sex = rand(sexRNG) < species.sex_ratio ? true : false
    return SexualIndividual{N,S}(new_genome, sex, species)
end

function crossover_from(individuals::AbstractArray{I}, target_amount::Int=1; mateRNG::AbstractRNG=Random.GLOBAL_RNG, mutateRNG::AbstractRNG=Random.GLOBAL_RNG, courtRNG::AbstractRNG=Random.GLOBAL_RNG) where I<:AsexualIndividual
    return [crossover(rand(courtRNG, individuals, 2)...; mateRNG=mateRNG, mutateRNG=mutateRNG) for _ in 1:target_amount]
end

function crossover_from(individuals::AbstractArray{I}, target_amount=1; mateRNG::AbstractRNG=Random.GLOBAL_RNG, mutateRNG::AbstractRNG=Random.GLOBAL_RNG, courtRNG::AbstractRNG=Random.GLOBAL_RNG, sexRNG::AbstractRNG=Random.GLOBAL_RNG) where I<:SexualIndividual
    (posInds, negInds) = separate_sex(individuals)

    posInds = eliminate(posInds, individuals[1].species.sex_selectivity)[1]

    return [crossover(rand(courtRNG, posInds), rand(courtRNG, negInds); sex_check=false, mateRNG=mateRNG, mutateRNG=mutateRNG, sexRNG=sexRNG) for _ in 1:target_amount]
end
