using Documenter, Univariate

makedocs(;
    modules=[Univariate],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/wakakusa/Univariate.jl/blob/{commit}{path}#L{line}",
    sitename="Univariate.jl",
    authors="wakakusa",
    assets=String[],
)

deploydocs(;
    repo="github.com/wakakusa/Univariate.jl",
)
