
## Julia Seismic Data Container

module JSDC

	function segy_scan(pathtoread::String,filefilter::String,header_bytes::Array,block_size::Int)
		println("$pathtoread$filefilter")

		# Find files in dir that match filter
		files_in = dir_scan(pathtoread,filefilter)
		nfiles = length(files_in)

		make_compressed_headers(pathtoread,files_in,header_bytes,block_size)
	end
	export segy_scan

	function dir_scan(pathtoread::String,filefilter::String)
		## Parses pathtoread for files that match filefilter

		# Find all files in dir
		dir = readdir("$pathtoread")	

		# Apply filter to files in dir
		files_out = filter(x -> contains(x,filefilter),dir)		

		return files_out
	end

	function make_compressed_headers(pathtoread,files_in,header_bytes,block_size)
		## Strip out metadata and save

		println("$header_bytes $block_size $files_in")	
			
	end
end


























