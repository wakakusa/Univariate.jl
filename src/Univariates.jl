module Univariates

#パッケージの読み込み
using DataFrames,StatsBase#,Plots,StatsPlots,GR
include("univariate.jl")
include("groupbycolunivariate.jl")

export numericsummary,summarymerge,univariate
export groupbycolnumericsummary,groupbycolnonnumericsummary,groupbycolunivariate
end # module
