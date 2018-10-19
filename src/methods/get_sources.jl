export get_sources

"""
    get_sources(con::SeisCon)

Returns an array of the source location coordinate pairs, NOT the minimum and maximum values.
Unlike `get_headers`, `get_sources` checks to make sure that SourceX and SourceY are consistant
throughout each block, that is `min == max`. 

Column 1 of the returned array is SourceX, and Column 2 is SourceY.

# Example

sx = get_sources(s)

"""
function get_sources(con::SeisCon)

    sx_v = get_header(con, "SourceX")
    sy_v = get_header(con, "SourceY")
    
    sx_const = all([sx_v[i,1] == sx_v[i,2] for i in 1:size(sx_v)[1]])
    sy_const = all([sy_v[i,1] == sy_v[i,2] for i in 1:size(sy_v)[1]])
    
    if sx_const && sy_const
        sx = [sx_v[i,1] for i in 1:size(sx_v)[1]]
        sy = [sy_v[i,1] for i in 1:size(sy_v)[1]]
    else
        @error "Source locations are not constistant for all blocks."
    end

    return hcat(sx,sy)

end
