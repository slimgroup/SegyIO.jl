export scan_chunk

function scan_chunk!(s::IO, max_blocks_per_chunk::Int, mem_block::Int, mem_trace::Int,
                    keys::Array{String,1}, file::String, scan::Array{BlockScan,1}, count::Int)

    # Load chunk into memory and get nblocks in this chunk
    chunk_start = position(s)
    buf = IOBuffer(read(s, max_blocks_per_chunk*mem_block)) 
    buf_size = position(seekend(buf))
    seekstart(buf)
    nblocks_chunk = Int(ceil(buf_size/mem_block))
    th_byte2sample = SegyIO.th_byte2sample()

    # Scan all blocks in this chunk
    for b in 1:nblocks_chunk
        scan[count] = scan_block(buf, mem_block, mem_trace, keys, chunk_start, file, th_byte2sample)
        count += 1
    end # b
    
    close(buf)
    return count
end
