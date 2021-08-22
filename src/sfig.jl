function sfig(p::Plots.Plot, arg, args...)
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
