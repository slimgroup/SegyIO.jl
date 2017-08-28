export read_con

function read_con(con::SeisCon, keys::Array{String,1}; blocks::Array{Int,1} = Array(1:size(con)),
                                prealloc_traces::Int = 10000)
    gc_enable(false) 
    nblocks = length(blocks)

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
            println("no room")
            data = hcat(data, Array{datatype,2}(con.ns, ntraces+prealloc_traces))
            headers = vcat(headers, Array{BinaryTraceHeader,1}(ntraces+prealloc_traces))
        end
        tmp_data = view(data, :,(trace_count+1):(trace_count+ntraces))
        tmp_headers = view(headers, (trace_count+1):(trace_count+ntraces)) 

        # Read the next block
        read_block!(con.blocks[block], keys, con.ns, con.dsf, tmp_data, tmp_headers)
        trace_count += ntraces
    end
    gc_enable(true)
    gc()
    return SeisBlock{datatype}(fh, headers[1:trace_count], data[:,1:trace_count])
    
end
