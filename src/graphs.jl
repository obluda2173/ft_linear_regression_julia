using Plots # for plots, obvious
using DataFrames # to store table data
using CSV

file_path = "../data/data.csv"

# now data is our dataframe holder of the dataset
data = CSV.read(file_path, DataFrame)

# println(data)

mileage = plot(
    xlabel="mileage (km)",
    ylabel="cost (shekels)",
    data.km,
    data.price,
    seriestype=:scatter
)

savefig(mileage, "mileage_plot.png")
