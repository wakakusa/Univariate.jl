using Documenter, Univariates

makedocs(;
    modules=[Univariates],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/wakakusa/Univariates.jl/blob/{commit}{path}#L{line}",
    sitename="Univariates.jl",
    authors="wakakusa",
    assets=String[],
)

deploydocs(;
    repo="github.com/wakakusa/Univariates.jl",
)
