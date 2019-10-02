import Base.merge,Base.==

export merge, ==

"""
    merge(cons::Array{SeisCon,1})

Merge the elements of `con`, a vector of SeisCon objects, into one SeisCon object. 
"""
function merge(cons::Array{SeisCon,1})
    
    # Check similar metadata
    ns = get_confield(cons, :ns)
    dsf = get_confield(cons, :dsf)

    if all(ns.==ns[1]) && all(dsf.==dsf[1])
        d = [cons[i].blocks for i in 1:length(cons)]
        return SeisCon(ns[1], dsf[1], vcat(d...))
    else
        @error "Dissimilar metadata, cannot merge"
    end
end

"""
    merge(a::SeisCon, b::SeisCon)

Merge two SeisCon objects together
"""
merge(a::SeisCon, b::SeisCon) = merge([a; b])


"""
    merge(a::SeisBlock, b::SeisBlock; kwargs...)

Merge two SeisBlocks into one.
"""
function merge(a::SeisBlock{DT}, b::SeisBlock{DT};
               force::Bool = false, consume::Bool = false) where {DT<:Union{IBMFloat32, Float32}}
   merge([a; b], force = force, consume = consume) 
end

"""
    merge(a::SeisBlock{DT}, b::SeisBlock{DT};
               force::Bool = false, consume::Bool = false) where {DT<:Union{IBMFloat32, Float32}}

Merge `blocks`, a vector of `SeisBlock` objects into one `SeisBlock` object.

By default, `merge` checks to ensure that each `SeisBlock` has matching fileheaders. This ensures
that the returned `SeisBlock` is consistant with it's fileheader. This check can be turned off
using the `force` keyword. If set to false, `merge` will attempt to combine `blocks` without
checking fileheader metadata. The first fileheader in `blocks` will be used for the  returned 
`SeisBlock`'s fileheader. 

By default, `merge` references traceheaders, but copies data from the elements of `blocks`. 
If memory use is a concern, the `consume` keyword will clear the traceheader and data field of each 
element of `block` after it has been copied. This will prevent duplicating the data in memory,
at the cost of clearing the elements of `blocks`.
    
# Examples

    julia> s = segy_scan(joinpath(dirname(pathof(SegyIO)),"data/"), "overthrust", ["GroupX"; "GroupY"], verbosity = 0);

    julia> a = s[1:4]; b = s[5:8];

    julia> c = merge([a; b]);

    julia> c.traceheaders[1] === a.traceheaders[1]
    true

    julia> c = merge([a; b], consume = true);

    julia> a.traceheaders
    0-element Array{SegyIO.BinaryTraceHeader,1}

"""
function merge(blocks::Vector{SeisBlock{DT}};
               force::Bool = false, consume::Bool = false) where {DT<:Union{IBMFloat32, Float32}}

    # Check common file header
    n = length(blocks)
    if !force && !all([blocks[i].fileheader == blocks[i+1].fileheader for i in 1:n-1])
        @error "Fileheaders do not match for all blocks, use kw force=true to ignore"
    end

    fh = blocks[1].fileheader
    bth = Vector{BinaryTraceHeader}()
    data = Vector{DT}()
    for ii in 1:n
        if consume
            append!(bth, blocks[ii].traceheaders[:])
            append!(data, blocks[ii].data[:])
            (blocks[ii].data = Array{DT}(undef,0,0))
            (blocks[ii].traceheaders = Array{BinaryTraceHeader}(undef,0))
        else
            append!(bth, @view blocks[ii].traceheaders[:])
            append!(data, blocks[ii].data[:])
        end
    end

    out = SeisBlock(fh, bth, reshape(data, Int64(fh.bfh.ns), :))
end



function ==(a::FileHeader, b::FileHeader)
    match_th = a.th == b.th
    match_bfh = [getfield(a.bfh, field) == getfield(b.bfh,field) for field in fieldnames(BinaryFileHeader)]
    return match_th && all(match_bfh)
end
