using CSV
using DataFrames

const MODEL_FILE = "thetas.csv"

df = CSV.read(MODEL_FILE, DataFrame)

estimate_price(mileage, t0, t1) = muladd(mileage, t1, t0)

function main()
    if !isfile(MODEL_FILE)
        error("Model file not found. \nUsed path: $MODEL_FILE")
    end
    df = CSV.read(MODEL_FILE, DataFrame)

    println("Esimate car price based on mileage.")
    print("Enter mileage: ")
    mileage = parse(Float64, readline())
    mileage_norm = (mileage - df.mu[1]) / df.sigma[1]
    estimated_price = estimate_price(mileage_norm, df.theta_0[1], df.theta_1[1])
    println(df)
    println("estimated_price = estimate_price($(mileage_norm), $(df.theta_0[1]), $(df.theta_1[1]))")
    println("Estimated price: $estimated_price")
end

main()
