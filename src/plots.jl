using CSV
using DataFrames
using Plots

const DATA_PATH = "../data/data.csv"
const MODEL_FILE = "thetas.csv"

function f(x_raw)
    if !isfile(MODEL_FILE)
        error("File not found: $MODEL_FILE")
    end
    model = CSV.read(MODEL_FILE, DataFrame)

    x_norm = (x_raw - model.mu[1]) / model.sigma[1]

    return x_norm * model.theta_1[1] + model.theta_0[1]
end

function main()
    if !isfile(DATA_PATH)
        error("File not found: $DATA_PATH")
    end
    data = CSV.read(DATA_PATH, DataFrame)


    plt = plot(data.km, data.price,
               xlabel="km",
               ylabel="price",
               seriestype=:scatter)

    plt = plot!(f, minimum(data.km):maximum(data.km),
                label="prediction line",
                linewidth=2)

    savefig("../plots/km_vs_price.png")
end

main()
