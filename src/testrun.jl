using SeisDataContainer

pathtofiles = "/data/slim/klensink/test/iotest/"
filename = ".sgy"
block_size = 1000
header_bytes = [73 77 81 85]
testout = segy_scan(pathtofiles,filename,header_bytes,block_size)

