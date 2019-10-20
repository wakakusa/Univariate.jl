function groupbycolnumericsummary(INPUT::Union{Array,DataFrame},groupbycol::String)  #数値型の基本統計量の算出
    SummaryVar=StatsBase.var(INPUT)
    SummaryStd=StatsBase.std(INPUT)
    SummaryQuartile=StatsBase.quantile( INPUT , [0.00, 0.25, 0.50, 0.75, 1.00])
    SummaryMedian=StatsBase.median(INPUT)
    SummaryMean=StatsBase.mean(INPUT)
  
    Output=DataFrame(colname=groupbycol,Var=SummaryVar,Std=SummaryStd,Mean=SummaryMean, Min=SummaryQuartile[1] ,Quartile1st=SummaryQuartile[2] ,Median=SummaryMedian,Quartile3rd=SummaryQuartile[4],Max=SummaryQuartile[5])
  
    return Output
end

function groupbycolnonnumericsummary(INPUT::Union{Array,DataFrame},groupbycol::Symbol,staticstargetcol::Symbol,setcolnames::Array)  #非数値型の基本統計量の算出
    result=zeros(Int,1,size(setcolnames,1)-1)
    result=DataFrame(result,Vector(setcolnames[2:end]))

    result=hcat(DataFrame(Matrix{Union{Any,Missing}}(missing,1,1)),result)
    names!(result,setcolnames)

    Output=by(INPUT, staticstargetcol, df -> size(df, 1))
    result[1,groupbycol]=INPUT[1,groupbycol]

    for i in Output[:,staticstargetcol]
        result[1,Symbol(i)]=Output[Output[:,staticstargetcol] .==i , 2][1]
    end

    return result
end

function groupbycolunivariate(INPUT::DataFrame,groupbycol::Symbol,staticstargetcol::Symbol)
    colname=sort(unique(INPUT[:,groupbycol]))
    SummaryNum=DataFrame(colname="",Var=0.0,Std=0.0,Mean=0.0, Min=0.0 ,Quartile1st=0.0 ,Median=0.0,Quartile3rd=0.0,Max=0.0)
    SummaryNonNum=DataFrame(colname="",hist=0)
    firstresultflag=true

    if eltype(INPUT[:,staticstargetcol]) <: Real
        for i in colname
            work=INPUT[INPUT[:,groupbycol] .== i,:]
            if (firstresultflag)
                SummaryNum=groupbycolnumericsummary(work[:,staticstargetcol],i) 
                firstresultflag=false
            else
                SummaryNum=vcat(SummaryNum,groupbycolnumericsummary(work[:,staticstargetcol],i) )
            end
        end
    else #非数値
        setcolnames=vcat(groupbycol,sort(union(INPUT[:,staticstargetcol])))
        setcolnames=map(Symbol,setcolnames)
        for i in colname
            work=INPUT[INPUT[:,groupbycol] .== i,:]
            if (firstresultflag)
                SummaryNonNum=groupbycolnonnumericsummary(work,groupbycol,staticstargetcol,setcolnames)
                firstresultflag=false
            else
                SummaryNonNum=vcat(SummaryNonNum,groupbycolnonnumericsummary(work,groupbycol,staticstargetcol,setcolnames) )
            end
        end
    end

    if eltype(INPUT[:,staticstargetcol]) <: Real
        result=SummaryNum
    else
        result=SummaryNonNum
    end

    return result
end
