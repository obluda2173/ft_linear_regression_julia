using Plots
using DataFrames
using CSV
using Statistics

const DATA_PATH = "../data/data.csv"
const THETAS_FILE = "thetas.csv"

# km, price
data = CSV.read(DATA_PATH, DataFrame)

x_mean = mean(data.km)
x_std = std(data.km)
x_norm = (data.km .- x_mean) ./ x_std
y = data.price


theta_0 = 0.0
theta_1 = 0.0
lr = 0.0001


function estimate_price(mileage, t0, t1)
    return mileage * t1 + t0
end

function calculate_theta_0(data_x, data_y, t0, t1)
    sum = 0.0
    m = length(data_x)

    for i in 1:m
        sum += estimate_price(data_x[i], t0, t1) - data_y[i]
    end

    return 1/m * sum
end

function calculate_theta_1(data_x, data_y, t0, t1)
    sum = 0.0
    m = length(data_x)

    for i in 1:m
        sum += (estimate_price(data_x[i], t0, t1) - data_y[i]) * data_x[i]
    end

    return 1/m * sum
end

for i in 1:1000000
    grad_0 = calculate_theta_0(x_norm, y, theta_0, theta_1)
    grad_1 = calculate_theta_1(x_norm, y, theta_0, theta_1)

    global theta_0 -= lr * grad_0
    global theta_1 -= lr * grad_1
end

println("Final Normalized theta_0: $theta_0")
println("Final Normalized theta_1: $theta_1")

raw_km = 82029
normalized_km = (raw_km - x_mean) / x_std

prediction = estimate_price(normalized_km, theta_0, theta_1)

println("Estimated price for $raw_km km: $prediction")

results = DataFrame(
    theta_0 = theta_0,
    theta_1 = theta_1,
    mu = x_mean,
    signma = x_std
)

CSV.write(THETAS_FILE, results)

##############
#   VISUALS  #
##############

# println(data)

# mileage = plot(
#     xlabel="mileage (km)",
#     ylabel="cost (shekels)",
#     data.km,
#     data.price,
#     seriestype=:scatter
# )

# savefig(mileage, "mileage_plot.png")
