using Univariates
using Test
using DataFrames,Tables

@testset "Univariates.jl" begin
    # Write your own tests here.
    ## テスト用データセット
    try
        include("../src/makeirisdataset.jl")
    catch
        packagemasterpath=DEPOT_PATH[1]
        try
            include(joinpath(packagemasterpath,"packages/Univariates/src/makeirisdataset.jl"))
        catch
            include(joinpath(packagemasterpath,"dev/Univariates/src/makeirisdataset.jl"))
        end
    end
    
    INPUT=makeirisdataset()

    ## 検証用データセット sasで作成
    colname1=["SepalLength","SepalWidth","PetalLength","PetalWidth"]
    Var=[68.56935123,18.997941834,311.62778523,58.100626398]
    Std=[8.2806612798,4.3586628494,17.652982333,7.6223766896]
    Mean=[58.433333333,30.573333333,37.58,11.993333333]
    Min=[43,20,10,1]
    Quartile1st=[51,28,16,3]
    Median=[58,30,43.5,13]
    Quartile3rd=[64,33,51,18]
    Max=[79,44,69,25]

    Var=map(Float64,Var)
    Std=map(Float64,Std)
    Mean=map(Float64,Mean)
    Min=map(Float64,Min)
    Quartile1st=map(Float64,Quartile1st)
    Median=map(Float64,Median)
    Quartile3rd=map(Float64,Quartile3rd)
    Max=map(Float64,Max)

    testnum=DataFrame(colname=colname1,Var=Var,Std=Std,Mean=Mean,Min=Min,Quartile1st=Quartile1st,Median=Median,Quartile3rd=Quartile3rd,Max=Max)

    colname2=["setosa","versicolor","virginica"]
    count=[50,50,50]
    testnonnum=DataFrame(Species=colname2,count=count)

    @testset "test1 univariate" begin
        SummaryNum,SummaryNonNum=univariate(INPUT,graphplot=true)
        @test map(x->floor(x,digits=7),Tables.Matrix(SummaryNum[:,2:end])) == map(x->floor(x,digits=7),Tables.Matrix(testnum[:,2:end])) 
        @test map(x->round(x,digits=8),Tables.Matrix(SummaryNum[:,2:end])) == map(x->round(x,digits=8),Tables.Matrix(testnum[:,2:end])) 
        @test SummaryNonNum==testnonnum
    end

    @testset "test2 groupbycolunivariate" begin
        INPUT=makeirisdataset()
        groupbycol=:SepalLength
        staticstargetcol=:Species
        groupbycolSummary=groupbycolunivariate(INPUT,groupbycol,staticstargetcol)
        @test permutedims(Vector(groupbycolSummary[10,[:setosa,:versicolor,:virginica]]))==[3 1 0]
        @test permutedims(Vector(groupbycolSummary[15,[:setosa,:versicolor,:virginica]]))==[2 5 1]  
        @test permutedims(Vector(groupbycolSummary[25,[:setosa,:versicolor,:virginica]]))==[0 3 5]

        groupbycol=:Species
        staticstargetcol=:SepalLength
        groupbycolSummary=groupbycolunivariate(INPUT,groupbycol,staticstargetcol)
        #sasでの算出結果
        sasans=[12.424897959 3.5248968721 50.06 43 48 50 52 58]
        result=Tables.Matrix(groupbycolSummary[groupbycolSummary[:,:colname] .=="setosa",[:Var,:Std,:Mean,:Min,:Quartile1st,:Median,:Quartile3rd,:Max]])
        @test map(x->floor(x,digits=7),result)==map(x->floor(x,digits=7),sasans)
        @test map(x->round(x,digits=8),result)==map(x->round(x,digits=8),sasans)
    end
end
