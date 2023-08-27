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
function _to_img(fn::AbstractString; clear = true, kwargs...) 
    return try
        FileIO.load(fn)
        finally; clear && rm(fn; force = true)
    end    
end

function _to_img(p; ext = "png", clear = true)
    fn = string(tempname(), ".", ext)
    return try
        sfig(p, fn)
        FileIO.load(fn)
        finally; clear && rm(fn; force = true)
    end
end

function _sgif(ps::Vector, arg, args...; 
        fps = 10.0
    ) 
    fn = dfname(arg, args...)
    !endswith(fn, ".gif") && error("filename must end with .gif")
    imgs = _to_img.(ps)
    mat = _make_mat(imgs)
    imgs = nothing # save memory ?
    FileIO.save(fn, mat; fps)
    return fn
end

## ----------------------------------------------------------------------------
sgif(ps, arg, args...; kwargs...) = _sgif(ps, arg, args...; kwargs...)
sgif(ps, fn::String = string(tempname(), ".gif"); kwargs...) = _sgif(ps, fn; kwargs...)

## ----------------------------------------------------------------------------
# function make_group_gif(freedim, sourcedir::String; 
#         filter = (filename) -> true, 
#         sortby = identity,
#         destdir = sourcedir,
#         verbose = true, 
#         fps = 3.0
#     )

#     dfg = group_files(freedim, sourcedir; filter)
#     gifs = []
#     for ((k, head, params, ext), elms) in dfg
#         gifname = dfname(head..., params, "gif")
#         giffile = joinpath(destdir, gifname)

#         selms = sort!(collect(elms); by = (p) -> sortby(first(p)))
#         paths = [file for (kv, file) in selms]

#         sgif(paths, giffile; fps)
#         verbose && @info("Gif produced", gifname)
#         push!(gifs, giffile)
#     end
#     gifs
# end