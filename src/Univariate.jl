module Univariate

#パッケージの読み込み
using  DataFrames , StatsBase #, Gadfly

export NumericSummary,SummaryMerge,Univariate

function NumericSummary(INPUT::Array,VarNames::Symbol)  #数値型の基本統計量の算出
  SummaryVar=StatsBase.var(INPUT)
  SummaryStd=StatsBase.std(INPUT)
  SummaryQuartile=StatsBase.quantile( INPUT , [0.00, 0.25, 0.50, 0.75, 1.00])
  SummaryMedian=StatsBase.median(INPUT)
  SummaryMean=StatsBase.mean(INPUT)

  Output=DataFrame(colname=VarNames,Var=SummaryVar,Std=SummaryStd,Mean=SummaryMean, Min=SummaryQuartile[1] ,Quartile1st=SummaryQuartile[2] ,Median=SummaryMedian,Quartile3rd=SummaryQuartile[4],Max=SummaryQuartile[5])

  return Output
end

function NonNumericSummary(INPUT::DataFrame,VarNames::Symbol)  #非数値型の基本統計量の算出
  Output=by(INPUT, VarNames, df -> size(df, 1))
  names!(Output,[VarNames,:count])

  return Output
end

function SummaryMerge(INPUT::DataFrame, Summary::DataFrame ,FirstMergeFlag::Bool)  #データの集約
  if FirstMergeFlag ==true
    Summary=INPUT
    FirstMergeFlag=false
  else
    Summary=vcat(Summary,INPUT)
  end

  return Dict( [("Summary",Summary),("FirstMergeFlag",FirstMergeFlag)])
end

function Univariate(INPUT)
  VarNames=names(INPUT)
  Vartype=eltypes(INPUT)
  SummaryNonNum=DataFrame(colname="",hist=0)
  SummaryNum=DataFrame(colname="",Var=0.0,Std=0.0,Mean=0.0, Min=0.0 ,Quartile1st=0.0 ,Median=0.0,Quartile3rd=0.0,Max=0.0)
  FirstMergeFlagNum=true
  FirstMergeFlagNonNum=true
 
  for  i = 1 : size(INPUT,2)
    if (( Vartype[i]==(Int) || Vartype[i]==(Float32)  || Vartype[i]== (Float64) ) == true )
      #数値型の基本統計量の算出
      work=NumericSummary(INPUT[:,i],VarNames[i])

      #基本統計量の集約
      SummaryNum=SummaryMerge(work,SummaryNum,FirstMergeFlagNum)["Summary"]
      FirstMergeFlagNum=SummaryMerge(work,SummaryNum,FirstMergeFlagNum)["FirstMergeFlag"]
    else
      #非数値型の基本統計量の算出
      work=NonNumericSummary(INPUT,VarNames[i])
      
      #基本統計量の集約
      SummaryNonNum=SummaryMerge(work,SummaryNonNum,FirstMergeFlagNonNum)["Summary"]
      FirstMergeFlagNonNum=SummaryMerge(work,SummaryNonNum,FirstMergeFlagNonNum)["FirstMergeFlag"]
    end   
  end

  return Dict([("SummaryNum",SummaryNum),("SummaryNonNum",SummaryNonNum)])
end



end # module
