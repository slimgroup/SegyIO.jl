export segy_scan, merge_con

"""
    segy_scan(dir::String, filt::String, keys::Array{String,1}, blocksize::Int; 
                           chunksize::Int = 1024,
                           pool::WorkerPool = WorkerPool(workers()))

Scan header fields `keys` of files in `dir` matching the filter `filt` in blocks
containing `blocksize` traces. The scanning of files is distributed to workers
in `pool`, default is all workers.

`chunksize` determines how many MB of data will be loaded into memory at a time.

"""
function segy_scan(dir::String, filt::String, keys::Array{String,1}, blocksize::Int; 
                    chunksize::Int = 1024,
                    pool::WorkerPool = WorkerPool(workers()))
    
    files = searchdir(dir, filt)
    run_scan(f) = scan_file(f, keys, blocksize, chunksize=chunksize)
    s = pmap(pool, run_scan, files)
    
    return merge_con(s)
end

searchdir(path,filt) = filter(x->contains(x,filt), readdir(path))

"""
    collect_cons(cons::Array{SeisCon,1})

Collect each SeisCon object in `cons` into one SeisCon. 
"""
function merge_con(cons::Array{SeisCon,1})
    
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

function get_confield(cons::Array{SeisCon,1}, name::Symbol)
    ncons = length(cons)
    out = zeros(Int64, ncons)
    for i in 1:ncons
        out[i] = getfield(cons[i], name)
    end
    return out
end
