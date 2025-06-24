const Genotype{N} = SVector{N,Bool}

abstract type Species end
abstract type SexualSpecies{N} <: Species end
abstract type AsexualSpecies{N} <: Species end
abstract type Individual end

struct SexualIndividual{N,S<:SexualSpecies{N}} <: Individual
    genome::Genotype{N}
    sex::Bool
    species::S
end

struct AsexualIndividual{N,S<:AsexualSpecies{N}} <: Individual
    genome::Genotype{N}
    species::S
end

function random_individual(species::S; indRNG::AbstractRNG=Random.GLOBAL_RNG, sexRNG::AbstractRNG=Random.GLOBAL_RNG) where S<:SexualSpecies{N} where N
    genome = Genotype{N}(rand(indRNG, Bool, N))
    sex = rand(sexRNG) < species.sex_ratio ? true : false
    return SexualIndividual{N,S}(genome, sex, species)
end

function random_individual(species::S; indRNG::AbstractRNG=Random.GLOBAL_RNG, sexRNG::AbstractRNG=Random.GLOBAL_RNG) where S<:AsexualSpecies{N} where N
    genome = Genotype{N}(rand(indRNG, Bool, N))
    return AsexualIndividual{N,S}(genome, species)
end

const Population{I<:Individual} = SVector{P,I} where P
Population(individuals::AbstractArray{I}) where I<:Individual = SVector{length(individuals),I}(individuals)

function random_population(species::S, amount::Int; indRNG::AbstractRNG=Random.GLOBAL_RNG, sexRNG::AbstractRNG=Random.GLOBAL_RNG) where S<:Species
    population = SVector{amount}([random_individual(species; indRNG=indRNG, sexRNG=sexRNG) for _ in 1:amount])
    return population
end