require 'rubygems'
require 'ap'
require 'pry'

class Turtle

	attr_reader :canvas, :pos

	def initialize(size)
		@pos = [ size / 2, size / 2 ]
		@orientation = 90
		@canvas = Canvas.new(size)
		grid[@pos[0]][@pos[1]] = "X"
		@offset = []
	end

	def grid
		@canvas.grid
	end

	def fd(step)
		calculate_offset
		0.upto(step-1) do |s|
			@pos[0] += @offset[1]
			@pos[1] += @offset[0]
			grid[@pos[0]][@pos[1]] = "X"
		end
	end

	def bk(step)
		calculate_offset
		0.upto(step-1) do |s|
			@pos[0] -= @offset[1]
			@pos[1] -= @offset[0]
			grid[@pos[0]][@pos[1]] = "X"
		end
	end

	def calculate_offset
		@offset = [ 1, 0 ] if @orientation == 0
		@offset = [ 1, -1 ] if @orientation == 45
		@offset = [ 0, -1 ] if @orientation == 90
		@offset = [ -1, -1 ] if @orientation == 135
		@offset = [ -1, 0 ] if @orientation == 180
		@offset = [ -1, 1 ] if @orientation == 225
		@offset = [ 0, 1 ] if @orientation == 270
		@offset = [ 1, 1 ] if @orientation == 315
	end

	def rt(degrees)
		@orientation = (@orientation - degrees) % 360
	end

	def lt(degrees)
		@orientation = (@orientation + degrees) % 360
	end

end

class Canvas

	attr_reader :grid

	def initialize(size)
		@grid = Array.new(size).map! { Array.new(size).map! { "." } }
	end

end

class Manager

	def initialize(filename)
		File.open(filename) do |file|
			size = file.gets
			file.gets
			@turtle = Turtle.new(size.to_i)
			while line = file.gets
				eval(line)
			end
		end
	end

	def write_logo(filename)
		File.open(filename, "w") do |f|
			@turtle.grid.each do |x|
				f.puts x.join(" ")
			end
		end
	end
	def eval(line)
		repeat = Regexp.new(/REPEAT \d+/)
		command = Regexp.new(/^(RT|FD|LT|BK) (\d+)/)
		if line.match(repeat)
			r = line.scan(/(([A-Z]+) ([0-9]+))/)
			1.upto(r[0][2].to_i) do |x|
				1.upto(r.size - 1) do |y|
					eval(r[y][0])
				end
			end
		end
		
		if line.match(command)
			c = line.scan(command)[0]
			@turtle.rt(line[/\d{1,3}/].to_i) if c[0] == "RT"
			@turtle.fd(line[/\d{1,3}/].to_i) if c[0] == "FD"
			@turtle.lt(line[/\d{1,3}/].to_i) if c[0] == "LT"
			@turtle.bk(line[/\d{1,3}/].to_i) if c[0] == "BK"									
		end
	end
end
m = Manager.new(ARGV[0]) if ARGV[0] != nil
m.write_logo(ARGV[1]) if ARGV[1] != nil
