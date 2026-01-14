using CSV
using DataFrames

include("config.jl")
using .Config

estimate_price(mileage, t0, t1) = muladd(mileage, t1, t0)

function get_mileage_bounds(filepath::String)
    if !isfile(filepath)
        error("Data file not found: $filepath")
    end
    df = CSV.read(filepath, DataFrame)
    return extrema(df.km)
end

function get_valid_input(min_km, max_km)
    print("Enter mileage: ")
    input_str = readline()

    val = tryparse(Float64, input_str)

    if isnothing(val)
        println("Error: Input is not a valid number.")
        return nothing
    elseif val < 0
        println("Error: Mileage cannot be negative.")
        return nothing
    elseif !(min_km <= val <= max_km)
        println("Error: Mileage $val is out of valid range [$min_km, $max_km].")
        return nothing
    end

    return val
end

function main()
    if !isfile(MODEL_FILE)
        error("Model file not found: $MODEL_FILE. Please run training first.")
    end

    model_df = CSV.read(MODEL_FILE, DataFrame)
    theta_0 = model_df.theta_0[1]
    theta_1 = model_df.theta_1[1]
    mu      = model_df.mu[1]
    sigma   = model_df.sigma[1]

    min_km, max_km = get_mileage_bounds(DATA_PATH)

    println("Estimate car price based on mileage.")
    println("(Valid range: $min_km - $max_km km)")

    mileage_raw = get_valid_input(min_km, max_km)

    if !isnothing(mileage_raw)
        mileage_norm = (mileage_raw - mu) / sigma
        estimated_price = estimate_price(mileage_norm, theta_0, theta_1)

        println("Estimated price: $(round(estimated_price, digits=2))")
    end
end

main()
