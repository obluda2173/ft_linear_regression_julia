module Config

export DATA_PATH, MODEL_FILE

const PROJECT_ROOT = dirname(@__DIR__)
const DATA_PATH = joinpath(PROJECT_ROOT, "data", "data.csv")
const MODEL_FILE = joinpath(PROJECT_ROOT, "models", "thetas.csv")

end
