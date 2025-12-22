using CSV
using DataFrames
using Plots
using Statistics

include("config.jl")
using .Config

if !isfile(MODEL_FILE)
    error("File not found: $MODEL_FILE")
end
model = CSV.read(MODEL_FILE, DataFrame)

const mu = model.mu[1]
const sigma = model.sigma[1]
const theta_0 = model.theta_0[1]
const theta_1 = model.theta_1[1]


function f(x_raw)
    x_norm = (x_raw - mu) / sigma
    return x_norm * theta_1 + theta_0
end

function plot_bfl(data, plt)
    x = data.km
    y = data.price

    b = cov(x, y) / var(x)

    c = mean(y) - b * mean(x)
    plt = plot!(x -> b*x + c, minimum(x), maximum(x), label="Exact Fit")
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

    savefig("../plots/km_vs_price_scatter.png")

    plt = plot!(f, minimum(data.km):maximum(data.km),
                label="prediction line",
                linewidth=2)

    plot_bfl(data, plt)

    savefig("../plots/km_vs_price.png")
end

main()
