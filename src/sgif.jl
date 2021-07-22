## ----------------------------------------------------------------------------
function plot_to_img(p::AbstractPlot; ext = "png", clear = true)
    fn = string(tempname(), ".", ext)
    try
        Plots.savefig(p, fn)
        return FileIO.load(fn)
    finally
        clear && rm(fn; force = true)
    end
end

## ----------------------------------------------------------------------------
function _make_mat(imgs)
    isempty(imgs) && error("imgs is empty")
    length(unique!(size.(imgs))) != 1 && error("All imgs must have the same size")
    
    w, h = size(first(imgs))
    d = length(imgs)
    img_mat = Array{RGB{N0f8}}(undef, w, h, d)
    @views for (i, img) in enumerate(imgs)
        img_mat[:, :, i] = img[:, :]
    end
    img_mat
end

## ----------------------------------------------------------------------------
function _sgif(imgs::Vector, arg, args...; 
        fps = 10.0
    ) 
    file = dfname(arg, args...)
    !endswith(file, ".gif") && error("filename must end with .gif")
    mat = _make_mat(imgs)
    imgs = nothing # save memory ?
    FileIO.save(file, mat; fps)
    return file
end

function sgif(ps::Vector{T}, arg, args...; 
        kwargs...
    ) where {T<:AbstractPlot}
    imgs = plot_to_img.(ps)
    _sgif(imgs, arg, args...; kwargs...)
end

function sgif(sourcepaths::Vector{String}, arg, args...; 
        kwargs...
    ) 
    imgs = FileIO.load.(sourcepaths)
    _sgif(imgs, arg, args...; kwargs...)
end

sgif(ps, fn::String = string(tempname(), ".gif"); kwargs...) = sgif(ps, fn; kwargs...)

## ----------------------------------------------------------------------------
function make_group_gif(freedim, sourcedir::String; 
        filter = (filename) -> true, 
        sortby = identity,
        destdir = sourcedir,
        verbose = true, 
        fps = 3.0
    )

    dfg = group_files(freedim, sourcedir; filter)
    gifs = []
    for ((k, head, params, ext), elms) in dfg
        gifname = dfname(head..., params, "gif")
        giffile = joinpath(destdir, gifname)

        selms = sort!(collect(elms); by = (p) -> sortby(first(p)))
        paths = [file for (kv, file) in selms]

        sgif(paths, giffile; fps)
        verbose && @info("Gif produced", gifname)
        push!(gifs, giffile)
    end
    gifs
end