using CSV
using DataFrames
using Statistics

include("config.jl")
using .Config

estimate_price(mileage, t0, t1) = muladd(mileage, t1, t0)

function main()
    if !isfile(MODEL_FILE)
        error("File not found: $MODEL_FILE")
    end
    df = CSV.read(MODEL_FILE, DataFrame)
    mu = df.mu[1]
    sigma = df.sigma[1]
    theta_0 = df.theta_0[1]
    theta_1 = df.theta_1[1]


    if !isfile(DATA_PATH)
        error("File not found: $DATA_PATH")
    end
    data = CSV.read(DATA_PATH, DataFrame)
    y_actual = data.price
    x = data.km

    y_predicted = [estimate_price((km - mu)/sigma, theta_0, theta_1) for km in x]

    ss_res = sum((y_actual .- y_predicted).^2)
    ss_tot = sum((y_actual .- mean(y_actual)).^2)
    r_squared = 1 - (ss_res / ss_tot)

    println("Precision (R^2 Score): $r_squared")
end

main()
