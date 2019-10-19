module Univariate

#パッケージの読み込み
using DataFrames,StatsBase,Plots,StatsPlots,GR
include("univariate.jl")
include("tableunivariate.jl")

export numericsummary,summarymerge,univariate
export tablenumericsummary,tablenonnumericsummary,tableunivariate
end # module
