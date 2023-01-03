export extract_con_headers

"""
extract_con_headers(con::SeisCon, keys::Array{String,1}, blocks::Array{Int,1};
                                prealloc_traces::Int = 50000)

Read `keys` from `blocks` in `con`. Skips all data and only reads and returns headers in an array.
This method is similar to `read_con_headers`, except the data is returned

# Examples

h = extract_con_headers(s, ["SourceX"; "SourceY"], Array(1:11))
"""
function extract_con_headers(con::SeisCon, keys::Array{String,1}, blocks::Vector;
                                                    f_map::Function = pmap)
    nblocks = length(blocks)
    h = f_map(x -> extractor(con, keys, x), blocks) 
    return vcat(h...)
end

function extract_con_headers(con::SeisCon, keys::Array{String,1}, blocks::Vector, reducer::Function;
                                                    f_map::Function = pmap)
    nblocks = length(blocks)
    h = f_map(x -> reducer(extractor(con, keys, x)), blocks) 
    return vcat(h...)
end

function extractor(con, keys, block)
    
    println("Extracting ... $block")
    headers = read_con_headers(con, copy(keys), block, prealloc_traces = 10000000)
    ntraces = length(headers)
    nkeys = length(keys)  
    header_array = Array{Int32, 2}(undef, ntraces, nkeys)

    for cur_key in 1:nkeys
        header_array[:,cur_key] = get_header(headers, Symbol(keys[cur_key]), scale=false)
    end
    
    return header_array
end
