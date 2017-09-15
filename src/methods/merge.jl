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
        throw(error("Dissimilar metadata, cannot merge"))
    end
end

"""
    merge(a::SeisCon, b::SeisCon)

Merge two SeisCon objects together
"""
merge(a::SeisCon, b::SeisCon) = merge([a; b])

"""
    merge{DT<:Union{IBMFloat32, Float32}}(blocks::Vector{SeisBlock{DT}};
                                                    force::Bool = false,
                                                    consume::Bool = false)

Merge
    

"""
function merge{DT<:Union{IBMFloat32, Float32}}(blocks::Vector{SeisBlock{DT}};
                                                    force::Bool = false,
                                                    consume::Bool = false)

    # Check common file header
    n = length(blocks)
    if !force && !all([blocks[i].fileheader == blocks[i+1].fileheader for i in 1:n-1])
        throw(error("Fileheaders do not match for all blocks, use kw force=true to ignore"))
    end

    fh = blocks[1].fileheader
    bth = Vector{BinaryTraceHeader}()
    data = Vector{DT}()
    for ii in 1:n
        if consume
            append!(bth, blocks[ii].traceheaders[:])
            append!(data, blocks[ii].data[:])
            (blocks[ii].data = Array{DT}(0,0))
            (blocks[ii].traceheaders = Array{BinaryTraceHeader}(0))
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
