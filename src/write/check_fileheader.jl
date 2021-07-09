export check_fileheader

function check_fileheader(s::IO, fh_new::FileHeader)

    # Check text header length
    if sizeof(fh_new.th) > 3200 @error "Text Header longer than 3200 bytes" end

    # Check dsf
    if fh_new.bfh.DataSampleFormat != 5
        @warn "DataSampleFormat not supported for writing. Attempting to convert to IEEE Float32"
        fh_new.bfh.DataSampleFormat = 5
    end

    # read fileheader of the existing file
    fh = read_fileheader(s)

    # Check first section of assigned values

    for field in fieldnames(typeof(fh.bfh))[1:end]
        if(getfield(fh.bfh, field) != getfield(fh_new.bfh, field)) @error "The existing fileheaders are different from the new SeisBlock" end
    end

    return true
    
end
