


include("src/BioticGeneticAlgorithme.jl")

struct Amoeba{N} <: AsexualSpecies{N}
    mutation_rate::Float64
end
Amoeba() = Amoeba{32}(0.001)

struct Yeast{N} <: SexualSpecies{N}
    mutation_rate::Float64
    sex_ratio::Float64
    sex_selectivity::Float64
end
Yeast() = Yeast{32}(0.001, 0.5, 0)

fixedSeeds = SimulationSeeds()
DataFrame(run_simulation(Amoeba(); amount=800, press=0.3, seeds=fixedSeeds))
DataFrame(run_simulation(Yeast(); amount=800, press=0.3, seeds=fixedSeeds))
DataFrame(run_simulation(Yeast{32}(0.001, 0.5, 0.2); amount=800, press=0.3, seeds=fixedSeeds))
DataFrame(run_simulation(Yeast{32}(0.001, 0.5, 0.9); amount=800, press=0.3, seeds=fixedSeeds))
