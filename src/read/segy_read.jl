export segy_read

"""
block = segy_read(file::String)
"""
function segy_read(file::AbstractString; buffer::Bool = true, warn_user::Bool = true)

    if buffer
        s = IOBuffer(read(open(file)))
    else
        s = open(file)
    end

    read_file(s, warn_user)
end

"""
block = segy_read(file::String, keys::Array{String,1})
"""
function segy_read(file::AbstractString, keys::Array{String,1}; buffer::Bool = true, warn_user::Bool = true)
    
    if buffer
        s = IOBuffer(read(open(file)))
    else
        s = open(file)
    end

    read_file(s, keys, warn_user)
end
