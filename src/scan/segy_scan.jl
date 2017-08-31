export segy_scan, merge_con

"""
    segy_scan(dir::String, filt::String, keys::Array{String,1}, blocksize::Int; 
                           chunksize::Int = 1024,
                           pool::WorkerPool = WorkerPool(workers()))

    returns: SeisCon

Scan header fields `keys` of files in `dir` matching the filter `filt` in blocks
containing `blocksize` continguous traces. The scanning of files is distributed to workers
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

"""
    segy_scan(dir::String, filt::String, keys::Array{String,1}; 
                           chunksize::Int = 1024,
                           pool::WorkerPool = WorkerPool(workers()))

If no `blocksize` is specified, the scanner automatically detects source locations and returns
blocks of continguous traces for each source location. 
"""
function segy_scan(dir::String, filt::String, keys::Array{String,1}; 
                    chunksize::Int = 1024,
                    pool::WorkerPool = WorkerPool(workers()))
    
    files = searchdir(dir, filt)
    run_scan(f) = scan_file(f, keys, chunksize=chunksize)
    s = pmap(pool, run_scan, files)
    
    return merge_con(s)
end

searchdir(path,filt) = filter(x->contains(x,filt), readdir(path))

"""
    merge_cons(cons::Array{SeisCon,1})

Merge `con`, a vector of SeisCon objects, into one SeisCon object. 
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

"""
    get_confield(cons::Array{SeisCon,1}, name::Symbol)

Returns an Array{Int32,1} containing the value in `name` field of each SeisCon object.
"""
function get_confield(cons::Array{SeisCon,1}, name::Symbol)
    ncons = length(cons)
    out = zeros(Int64, ncons)
    for i in 1:ncons
        out[i] = getfield(cons[i], name)
    end
    return out
end
