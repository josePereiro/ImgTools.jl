const MAKIE_PLOT_TYPE = Union{CairoMakie.Makie.FigureAxisPlot, CairoMakie.Makie.Figure}
function sfig(f::MAKIE_PLOT_TYPE, arg, args...)
    file = dfname(arg, args...)
    CairoMakie.save(file, f)
    return file
end

const PLOTS_PLOT_TYPE = Plots.Plot
function sfig(p::PLOTS_PLOT_TYPE, arg, args...)
    file = dfname(arg, args...)
    Plots.savefig(p, file)
    return file
end

function sfig(img::Matrix, arg, args...)
    file = dfname(arg, args...)
    FileIO.save(file, img)
    return file
end

function sfig(ps::Vector, arg, args...; kwargs...)
    file = dfname(arg, args...)
    grid = make_grid(ps; kwargs...)
    sfig(grid, file)
end
