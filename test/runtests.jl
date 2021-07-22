using ImgTools
using Test

@testset "ImgTools.jl" begin

    # single plot
    p = ImgTools.Plots.plot(rand(100); label = "")
    figfile = ImgTools.sfig(p, 
        [tempdir()], "test", (;A = 1), "png"
    )
    @test isfile(figfile)

    # miltiple plots
    ps = map(1:10) do _
        p = ImgTools.Plots.plot(rand(100); label = "")
    end
    figfile = ImgTools.sfig(ps, 
        [tempdir()], "test", (;A = 1), "png"
    )
    @test isfile(figfile)

    # gifs
    figfile = ImgTools.sgif(ps, 
        [tempdir()], "test", (;A = 1), "gif"
    )
    @test isfile(figfile)

    rm(figfile)

end
