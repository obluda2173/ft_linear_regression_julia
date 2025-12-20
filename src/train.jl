using CSV
using DataFrames
using Statistics

# constants
const DATA_PATH = "../data/data.csv"
const MODEL_FILE = "thetas.csv"


estimate_price(mileage, t0, t1) = muladd(mileage, t1, t0)

function compute_gradients(x, y, t0, t1)
    m = length(x)
    sum_diff_0 = 0.0
    sum_diff_1 = 0.0

    @simd for i in 1:m
        prediction = estimate_price(x[i], t0, t1)
        error = prediction - y[i]

        sum_diff_0 += error
        sum_diff_1 += error * x[i]
    end

    grad_0 = sum_diff_0 / m
    grad_1 = sum_diff_1 / m

    return grad_0, grad_1
end

function train_model(x, y, lr = 0.1, epochs = 10000)
    t0 = 0.0
    t1 = 0.0

    for i in 1:epochs
        grad_0, grad_1 = compute_gradients(x, y, t0, t1)
        t0 -= lr * grad_0
        t1 -= lr * grad_1
    end

    return t0, t1
end

function main()
    if !isfile(DATA_PATH)
        error("File not found: $DATA_PATH")
    end
    df = CSV.read(DATA_PATH, DataFrame)

    # normalisation
    x_mean = mean(df.km)
    x_std = std(df.km)
    x_norm = (df.km .- x_mean) ./ x_std
    y = df.price

    theta_0, theta_1 = train_model(x_norm, y, 0.1, 1000000)

    # save results
    results = DataFrame(
        theta_0 = theta_0,
        theta_1 = theta_1,
        mu = x_mean,
        sigma = x_std
    )
    CSV.write(MODEL_FILE, results)
    println("Model saved to $MODEL_FILE")
end

main()
