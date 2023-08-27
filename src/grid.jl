## ----------------------------------------------------------------------------
const RED_PIX = RGB{N0f8}(1.0,0.0,0.0)
const GREEN_PIX = RGB{N0f8}(0.0,1.0,0.0)
const BLUE_PIX = RGB{N0f8}(0.0,0.0,1.0)
const BLACK_PIX = RGB{N0f8}(0.0,0.0,0.0)
const WHITE_PIX = RGB{N0f8}(1.0,1.0,1.0)

## ----------------------------------------------------------------------------
function add_margin(a::Matrix, topm::Int, botm::Int, leftm::Int, rightm::Int, tofill)
    M, N = size(a)
    new_a = fill(tofill, M + topm + botm, N + leftm + rightm)
    M, N = size(new_a)
    new_a[(topm + 1):(M - botm), (leftm + 1):(N - rightm)] .= a
    new_a
end
add_margin(a::Matrix, m::Int, tofill) = add_margin(a, m, m, m, m, tofill)

## ----------------------------------------------------------------------------
function _auto_layout(d)
    w = round(Int, sqrt(d), RoundUp)
    h = round(Int, d / w, RoundUp)
    @assert w * h >= d
    (w, h)
end

## ----------------------------------------------------------------------------
function centered(img, d1_nsize, d2_nsize, tofill)
    d1_size, d2_size = size(img)
    any((d1_nsize, d2_nsize) .< (d1_size, d2_size)) && 
        error("size $((d1_size, d2_size)) do not fit in nsize $((d1_nsize, d2_nsize))")
    
    d1_marg0 = div(d1_nsize - d1_size, 2)
    d1_marg1 = d1_nsize - d1_size - d1_marg0

    d2_marg0 = div(d2_nsize - d2_size, 2)
    d2_marg1 = d2_nsize - d2_size - d2_marg0

    add_margin(img, d1_marg0, d1_marg1, d2_marg0, d2_marg1, tofill)
end
centered(img, gsize, tofill) = centered(img, gsize..., tofill)

## ----------------------------------------------------------------------------
function _compute_size(sizes, layout, margin)
    d1_img_count, d2_img_count = layout
    c = 1
    d1_img_sizes = Dict{Int, Int}()
    d2_img_sizes = Dict{Int, Int}()
    for d1_imgi in 1:d1_img_count
        for d2_imgi in 1:d2_img_count
            c > length(sizes) && break
            d1_size, d2_size = sizes[c] .+ 2 * margin
            d1_old_size = get!(d1_img_sizes, d1_imgi, 0)
            d1_img_sizes[d1_imgi] = max(d1_size, d1_old_size)

            d2_old_size = get!(d2_img_sizes, d2_imgi, 0)
            d2_img_sizes[d2_imgi] = max(d2_size, d2_old_size)
            c += 1
        end
    end
    return d1_img_sizes, d2_img_sizes
end

## ----------------------------------------------------------------------------
function _make_grid(arrs::Vector{Matrix{T}};
        layout = _auto_layout(length(arrs)),
        margin::Int = 5, 
        tofill::T = one(T)
    ) where {T}

    d1_img_count, d2_img_count = layout

    img_sizes = size.(arrs)
    d1_img_sizes, d2_img_sizes = _compute_size(img_sizes, layout, margin)

    d1_tot_size, d2_tot_size = sum(values(d1_img_sizes)), sum(values(d2_img_sizes))
    grid::Matrix{T} = fill(tofill, d1_tot_size, d2_tot_size)

    c = 1
    d1_img_idx0 = 1
    for d1_imgi in 1:d1_img_count
        
        d1_img_size = d1_img_sizes[d1_imgi]
        d1_img_idx1 = d1_img_idx0 + d1_img_size - 1
        d1_range = d1_img_idx0:d1_img_idx1
        
        d2_img_idx0 = 1
        for d2_imgi in 1:d2_img_count
            c > length(arrs) && break

            d2_img_size = d2_img_sizes[d2_imgi]
            d2_img_idx1 = d2_img_idx0 + d2_img_size - 1
            d2_range = d2_img_idx0:d2_img_idx1
            
            centered_a = centered(arrs[c], d1_img_size, d2_img_size, tofill)
            
            grid[d1_range, d2_range] .= centered_a
            c += 1

            d2_img_idx0 = d2_img_idx1 + 1
        end

        d1_img_idx0 = d1_img_idx1 + 1
    end
    grid
end

## ----------------------------------------------------------------------------
function make_grid(imgs::Vector; kwargs...)
    
    img_untyped_ = map(imgs) do img
        (img isa Matrix) ? img : _to_img(img)
    end

    T = eltype(first(img_untyped_))
    for img in img_untyped_
        T = promote_type(T, eltype(img))
    end

    imgs_typed_ = Vector{Matrix{T}}(undef, length(img_untyped_))
    for i in eachindex(img_untyped_)
        imgs_typed_[i] = img_untyped_[i]
    end
    img_untyped_ = nothing

    _make_grid(imgs_typed_; kwargs...)
end
