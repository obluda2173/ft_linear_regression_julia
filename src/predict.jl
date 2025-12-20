using CSV
using DataFrames

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

    println("Esimate car price based on mileage.")
    print("Enter mileage: ")
    mileage_string = readline()

    mileage_raw = parse(Float64, mileage_string)
    mileage_norm = (mileage_raw - mu) / sigma
    estimated_price = estimate_price(mileage_norm, theta_0, theta_1)

    println("Estimated price: $estimated_price")
end

main()
