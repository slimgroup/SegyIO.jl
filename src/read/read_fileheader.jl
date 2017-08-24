# Return the binary header from a SEGY file
export read_fileheader

"""
# Info

Use: fileheader = read_fileheader(s::IO; bigendian::Bool = true)

Returns a binary file header formed using bytes 3200-3600 from the stream 's'.
"""
function read_fileheader(s::IO; bigendian::Bool = true)

    # Initialize binary file header
    fileheader = BinaryFileHeader()
    fh_b2s = fh_byte2sample()

    # Return to start of stream
    seekstart(s)

    if bigendian
        # Read all header values and put in fileheader
        for k in keys(fh_b2s)

           # Seek to this header value location
           seek(s, fh_b2s[k])

           # Read into file header
           sym = Symbol(k)
           setfield!(fileheader, sym, bswap(read(s, typeof(getfield(fileheader, sym)))))
        end
    else
        # Read all header values and put in fileheader
        for k in keys(fh_b2s)

           # Seek to this header value location
           seek(s, fh_b2s[k])

           # Read into file header
           sym = Symbol(k)
           setfield!(fileheader, sym, read(s, typeof(getfield(fileheader, sym))))
        end
    end
    
    # Move to end of file header
    seek(s, 3600)
    return fileheader
end


"""
Use: fileheader = read_fileheader(s::IO, keys::Array{String,1}; bigendian::Bool = true)

Return a fileheader from stream 's' with the fields defined in 'keys'.

# Examples

Read the entire file header.

    julia> s = open("data/testdata.segy")
    IO(<file data/testdata.segy>)

    julia> fh = SeisIO.read_fileheader(s)
    SeisIO.BinaryFileHeader(9999, 9999, 1, 400, 0, 4000, 4000, 560, 560, 1, -13922, 4, 1, 0,
    0, 0, 0, 0, 0, 0, 0, 2, 1, 4, 2, 0, 0, 0, 0, 0, Dict("expf"=>3226,"sfe"=>3234,
    "rgc"=>3250,"jobid"=>3200,"dt"=>3216,"nsfr"=>3222,"slen"=>3236,"vpol"=>3258,"renum"=>3208,
    "dsf"=>3224…))

Read only the sample interval and number of traces from the file header.

    julia> s = open("data/testdata.segy")
    IO(<file data/testdata.segy>)

    julia> fh = SeisIO.read_fileheader(s, ["dt"; "ns"])
    SeisIO.BinaryFileHeader(0, 0, 0, 0, 0, 4000, 0, 560, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, Dict("expf"=>3226,"sfe"=>3234,"rgc"=>3250,"jobid"=>3200,
    "dt"=>3216,"nsfr"=>3222,"slen"=>3236,"vpol"=>3258,"renum"=>3208,"dsf"=>3224…))
"""
function read_fileheader(s::IO, keys::Array{String,1}; bigendian::Bool = true)

    # Initialize binary file header
    fileheader = BinaryFileHeader()
    fh_b2s = fh_b2s()

    # Return to start of stream
    seekstart(s)

    if bigendian
        # Read all header values and put in fileheader
        for k in keys

           # Seek to this header value location
           seek(s, fh_b2s[k])

           # Read into file header
           sym = Symbol(k)
           setfield!(fileheader, sym, bswap(read(s, typeof(getfield(fileheader, sym)))))
        end
    else
        # Read all header values and put in fileheader
        for k in keys

           # Seek to this header value location
           seek(s, fh_b2s[k])

           # Read into file header
           sym = Symbol(k)
           setfield!(fileheader, sym, read(s, typeof(getfield(fileheader, sym))))
        end
    end

    # Move to end of file header
    seek(s, 3600)

    return fileheader
end
