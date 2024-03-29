module ImgTools

    import Images
    import FileIO   
    import FixedPointNumbers: N0f8
    import Colors: RGB
    import Plots
    import CairoMakie
    import Plots: AbstractPlot
    import DataFileNames: dfname

    include("sgif.jl")
    include("grid.jl")
    include("ticks.jl")
    include("sfig.jl")
    include("lfig.jl")

    export sfig, lfig, sgif
    
end