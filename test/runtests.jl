using ImgTools
using Test

@testset "ImgTools.jl" begin

    # single plot
    for p in [
            ImgTools.Plots.plot(rand(100)), 
            ImgTools.CairoMakie.lines(rand(100)), 
        ]
        figfile = ImgTools.sfig(p, 
            [tempdir()], "test", (;A = 1), "png"
        )
        @test isfile(figfile)
        rm(figfile; force = true)
    end

    # miltiple plots
    for ps in [
        [ImgTools.Plots.plot(rand(100)) for p in 1:10], 
        [ImgTools.CairoMakie.lines(rand(100)) for p in 1:10], 
    ]
        figfile = ImgTools.sfig(ps, 
            [tempdir()], "test", (;A = 1), "png"
        )
        @test isfile(figfile)
        rm(figfile; force = true)

        # gifs
        figfile = ImgTools.sgif(ps, 
            [tempdir()], "test", (;A = 1), "gif"
        )
        @test isfile(figfile)
        rm(figfile; force = true)
    end

end
