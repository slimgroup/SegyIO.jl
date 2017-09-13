export read_con

"""
Use:   read_con(con::SeisCon; 
                blocks::Array{Int,1} = Array(1:length(con)),
                prealloc_traces::Int = 50000)

Read 'blocks' out of 'con' into a preallocated array of size (ns x prealloc_traces).

If preallocated memory fills, it will be expanded again by 'prealloc_traces'.
"""
function read_con(con::SeisCon, blocks::Array{Int,1}; 
                                prealloc_traces::Int = 50000)
    nblocks = length(blocks)
    maximum(blocks)>length(con) ? throw(error("Call for block $(maximum(blocks)) in a container with $(length(con)) blocks.")) : nothing

    # Check dsf
    datatype = Float32
    if con.dsf == 1
        datatype = IBMFloat32
    elseif con.dsf != 5
        error("Data type not supported ($(fh.bfh.DataSampleFormat))")
    end

    # Pre-allocate
    data = Array{datatype,2}(con.ns, prealloc_traces) 
    headers = Array{BinaryTraceHeader,1}(prealloc_traces) 
    fh = FileHeader(); set_fileheader!(fh.bfh, :ns, con.ns)
    set_fileheader!(fh.bfh, :DataSampleFormat, con.dsf)

    trace_count = 0
    # Read all blocks
    for block in blocks
        
        # Check size of next block and pass view to pre-alloc
        brange = con.blocks[block].endbyte - con.blocks[block].startbyte
        ntraces = Int((brange)/(240 + con.ns*4))

        # Check if there is room in pre-alloc'd mem
        isroom = (trace_count + ntraces) <= length(headers)
        if ~isroom
            println("Expanding preallocated memory")
            prealloc_traces *= 2
            data = hcat(data, Array{datatype,2}(con.ns, ntraces+prealloc_traces))
            append!(headers, Array{BinaryTraceHeader,1}(ntraces+prealloc_traces))
        end
        tmp_data = view(data, :,(trace_count+1):(trace_count+ntraces))
        tmp_headers = view(headers, (trace_count+1):(trace_count+ntraces)) 

        # Read the next block
        read_block!(con.blocks[block], con.ns, con.dsf, tmp_data, tmp_headers)
        trace_count += ntraces
    end

    return SeisBlock{datatype}(fh, headers[1:trace_count], data[:,1:trace_count])
    
end

function read_con(con::SeisCon, keys::Array{String,1}, blocks::Array{Int,1};
                                prealloc_traces::Int = 50000)
    nblocks = length(blocks)

    # Check dsf
    datatype = Float32
    if con.dsf == 1
        datatype = IBMFloat32
    elseif con.dsf != 5
        error("Data type not supported ($(fh.bfh.DataSampleFormat))")
    end

    # Check for RecSrcScalar
    in("RecSourceScalar", keys) ? nothing : push!(keys, "RecSourceScalar")

    # Pre-allocate
    data = Array{datatype,2}(con.ns, prealloc_traces) 
    headers = Array{BinaryTraceHeader,1}(prealloc_traces) 
    fh = FileHeader(); set_fileheader!(fh.bfh, :ns, con.ns)
    set_fileheader!(fh.bfh, :DataSampleFormat, con.dsf)

    trace_count = 0
    # Read all blocks
    for block in blocks
        
        # Check size of next block and pass view to pre-alloc
        brange = con.blocks[block].endbyte - con.blocks[block].startbyte
        ntraces = Int((brange)/(240 + con.ns*4))

        # Check if there is room in pre-alloc'd mem
        isroom = (trace_count + ntraces) <= length(headers)
        if ~isroom
            println("Expanding preallocated memory")
            data = hcat(data, Array{datatype,2}(con.ns, ntraces+prealloc_traces))
            append!(headers, Array{BinaryTraceHeader,1}(ntraces+prealloc_traces))
            prealloc_traces *= 2
        end
        tmp_data = view(data, :,(trace_count+1):(trace_count+ntraces))
        tmp_headers = view(headers, (trace_count+1):(trace_count+ntraces)) 

        # Read the next block
        read_block!(con.blocks[block], keys, con.ns, con.dsf, tmp_data, tmp_headers)
        trace_count += ntraces
    end

    return SeisBlock{datatype}(fh, headers[1:trace_count], data[:,1:trace_count])
    
end

# RANGES & INT
function read_con{TR<:Range}(con::SeisCon, blocks::TR;
                                prealloc_traces::Int = 50000)
    read_con(con, Array(blocks), prealloc_traces = prealloc_traces)
end
function read_con(con::SeisCon, blocks::Integer;
                                prealloc_traces::Int = 50000)
    read_con(con, [blocks], prealloc_traces = prealloc_traces)
end
function read_con{TR<:Range}(con::SeisCon, keys::Array{String,1}, blocks::TR;
                                prealloc_traces::Int = 50000)
    read_con(con, keys, Array(blocks), prealloc_traces = prealloc_traces)
end
function read_con(con::SeisCon, keys::Array{String,1}, blocks::Integer;
                                prealloc_traces::Int = 50000)
    read_con(con, keys, [blocks], prealloc_traces = prealloc_traces)
end

