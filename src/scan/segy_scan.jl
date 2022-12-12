export segy_scan

"""
    segy_scan(dir::String, filt::String, keys::Array{String,1}, blocksize::Int; 
              chunksize::Int = CHUNKSIZE,
              pool::WorkerPool = WorkerPool(workers()),
              verbosity::Int = 1)

    returns: SeisCon

Scan header fields `keys` of files in `dir` matching the filter `filt` in blocks
containing `blocksize` continguous traces. The scanning of files is distributed to workers
in `pool`, the default pool is all workers.

`chunksize` determines how many MB of data will be loaded into memory at a time.

`CHUNKSIZE` defaults to 2048MB.

`verbosity` set to 0 silences updates on the current file being scanned.

"""
function segy_scan(dir::AbstractString, filt::Union{String, Regex}, keys::Array{String,1}, blocksize::Int; 
                   chunksize::Int = CHUNKSIZE,
                   pool::WorkerPool = WorkerPool(workers()),
                   verbosity::Int = 1,
                   filter::Bool = true)
    
    endswith(dir, "/") ? nothing : dir *= "/"
    filter ? (filenames = searchdir(dir, filt)) : (filenames = [filt])
    files = map(x -> dir*x, filenames)
    files_sort = files[sortperm(filesize.(files), rev = true)]
    run_scan(f) = scan_file(f, keys, blocksize, chunksize=chunksize, verbosity=verbosity)
    s = pmap(run_scan, pool, files_sort)

    return merge(s)
end

"""
    segy_scan(dirs::Array{String,1}, filt::String, keys::Array{String,1}, blocksize::Int;
              chunksize::Int = CHUNKSIZE,
              pool::WorkerPool = WorkerPool(workers()),
              verbosity::Int = 1)

Scans all files whose name contains `filt` in each directory of `dirs` using `blocksize`.

"""
function segy_scan(dirs::Array{<:AbstractString,1}, filt::Union{String, Regex}, keys::Array{String,1}, blocksize::Int; 
                   chunksize::Int = CHUNKSIZE,
                   pool::WorkerPool = WorkerPool(workers()),
                   verbosity::Int = 1,
                   filter::Bool = true)
    
    files = Array{supertype(typeof(dirs[1]*"")), 1}()
    for dir in dirs 
        endswith(dir, "/") ? nothing : dir *= "/"
        filter ? (filenames = searchdir(dir, filt)) : (filenames = [filt])
        append!(files, map(x -> dir*x, filenames))
    end
    files_sort = files[sortperm(filesize.(files), rev = true)]
    run_scan(f) = scan_file(f, keys, blocksize, chunksize=chunksize, verbosity=verbosity)
    s = pmap(run_scan, pool, files_sort)
    
    return merge(s)
end

"""
    segy_scan(dir::String, filt::String, keys::Array{String,1},
              chunksize::Int = CHUNKSIZE,
              pool::WorkerPool = WorkerPool(workers()),
              verbosity::Int = 1)

If no `blocksize` is specified, the scanner automatically detects source locations and returns
blocks of continguous traces for each source location, but each block no larger then CHUNKSIZE. 

"""
function segy_scan(dir::AbstractString, filt::Union{String, Regex}, keys::Array{String,1}; 
                   chunksize::Int = CHUNKSIZE,
                   pool::WorkerPool = WorkerPool(workers()),
                   verbosity::Int = 1,
                   filter::Bool = true)
    
    endswith(dir, "/") ? nothing : dir *= "/"
    filter ? (filenames = searchdir(dir, filt)) : (filenames = [filt])
    files = map(x -> dir*x, filenames)
    files_sort = files[sortperm(filesize.(files), rev = true)]
    run_scan(f) = scan_file(f, keys, chunksize=chunksize, verbosity=verbosity)
    s = pmap(run_scan, pool, files_sort)
    
    return merge(s)
end

"""
    segy_scan(dirs::Array{String,1}, filt::String, keys::Array{String,1},
              chunksize::Int = CHUNKSIZE,
              pool::WorkerPool = WorkerPool(workers()),
              verbosity::Int = 1)

Scans all files whose name contains `filt` in each directory of `dirs`.

"""
function segy_scan(dirs::Array{<:AbstractString,1}, filt::Union{String, Regex}, keys::Array{String,1}; 
                   chunksize::Int = CHUNKSIZE,
                   pool::WorkerPool = WorkerPool(workers()),
                   verbosity::Int = 1,
                   filter::Bool = true)

    files = Array{supertype(typeof(dirs[1]*"")), 1}()
    for dir in dirs 
        endswith(dir, "/") ? nothing : dir *= "/"
        filter ? (filenames = searchdir(dir, filt)) : (filenames = [filt])
        append!(files, map(x -> dir*x, filenames))
    end
    files_sort = files[sortperm(filesize.(files), rev = true)]
    run_scan(f) = scan_file(f, keys, chunksize=chunksize, verbosity=verbosity)
    s = pmap(run_scan, pool, files_sort)
    
    return merge(s)
end

function searchdir(path, filt::String)
    filt = Regex(replace(filt, "*" => ".*."))
    filter!(x->occursin(filt, x),readdir(path))
end

function searchdir(path, filt::Regex)
    filter!(x->occursin(filt, x),readdir(path))
end