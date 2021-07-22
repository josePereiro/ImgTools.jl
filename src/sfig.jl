function sfig(p, arg, args...)
    file = dfname(arg, args...)
    Plots.savefig(p, file)
    return file
end

function sfig(ps::Vector, arg, args...; 
        layout = _auto_layout(length(ps)), 
        margin = 10
    )
    file = dfname(arg, args...)
    grid = make_grid(ps; layout, margin)
    FileIO.save(file, grid)
    return file
end
