struct SimulationSeeds
    indGen::UInt
    sex::UInt
    matePointer::UInt
    mutation::UInt
    courtship::UInt
end
SimulationSeeds() = SimulationSeeds(rand(UInt, 5)...)

struct SimulationRNG
    indGen::AbstractRNG
    sex::AbstractRNG
    matePointer::AbstractRNG
    mutation::AbstractRNG
    courtship::AbstractRNG
end
SimulationRNG(seeds::SimulationSeeds) = SimulationRNG(
    MersenneTwister(seeds.indGen),
    MersenneTwister(seeds.sex),
    MersenneTwister(seeds.matePointer),
    MersenneTwister(seeds.mutation),
    MersenneTwister(seeds.courtship)
)
SimulationRNG() = SimulationRNG(SimulationSeeds())