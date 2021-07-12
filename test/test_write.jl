# Test writing component of SegyIO
global key = ["GroupX";"GroupY";"SourceX";"SourceY"]
global dir = "../data/"
global file_filter = "test_write"

@testset "write" begin

	@testset "segy_write" begin
		block = SeisBlock(rand(Float32,10,10));
		set_header!(block, "dt", 6000);
		set_header!(block, :SourceX, 4000);
		set_header!(block, :SourceY, 4500);

		set_header!(block, :GroupX, 8000);
		set_header!(block, :GroupY, 8500);

		segy_write("../data/test_write.segy", block)
                
		s = segy_scan(dir,file_filter,key)
		
		@test size(s[1].data) == (10,10)
		@test get_header(s, "SourceX")[1] == 4000
                @test get_header(s, "SourceY")[1] == 4500 
                @test get_header(s, "GroupX")[1] == 8000
                @test get_header(s, "GroupY")[1] == 8500 
		@test get_header(s, "SourceX")[end] == 4000
                @test get_header(s, "SourceY")[end] == 4500 
                @test get_header(s, "GroupX")[end] == 8000 
                @test get_header(s, "GroupY")[end] == 8500 
	end


	@testset "segy_write_append" begin
		block_append = SeisBlock(rand(Float32,10,10));

		set_header!(block_append, "dt", 6000);
                set_header!(block_append, :SourceX, 4000);
                set_header!(block_append, :SourceY, 4500);

                set_header!(block_append, :GroupX, 8000);
                set_header!(block_append, :GroupY, 9000);

		segy_write_append("../data/test_write.segy", block_append)

		s = segy_scan(dir,file_filter,key)

                @test size(s[1].data) == (10,20)
		@test get_header(s, "SourceX")[1] == 4000
                @test get_header(s, "SourceY")[1] == 4500 
                @test get_header(s, "GroupX")[1] == 8000 
                @test get_header(s, "GroupY")[1] == 8500 
                @test get_header(s, "SourceX")[end] == 4000
                @test get_header(s, "SourceY")[end] == 4500
                @test get_header(s, "GroupX")[end] == 8000
                @test get_header(s, "GroupY")[end] == 9000
	end
end
