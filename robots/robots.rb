require 'rubygems'
require 'pry'

class Conveyor

	attr_reader :pos

	def initialize(belt_north, belt_south, robot)

		@belt_north = belt_north
		@belt_south = belt_south
		@pos = robot.index("X")

	end

	def eval(dir)

		click = 0
		p = @pos
		dmg = 0

		while p >= 0 && p <= @belt_north.length
			if click % 2 == 0
				dmg += 1 if @belt_north[p] == "|"
			else
				dmg += 1 if @belt_south[p] == "|"
			end

			click += 1
			p += 1 * dir
		end
		dmg
	end

	def best_direction
		eval(1) < eval(-1) ? "GO EAST" : "GO WEST"
	end

end

class FileManager


	def initialize(file_in)
		@conveyors = []

		File.open(file_in) do |file|
			while line = file.gets
				if line == "\n"
					line = file.gets
				end
				n = line
				b = file.gets
				s = file.gets
				@conveyors << Conveyor.new(n, s, b)
			end
		end
	end

	def write(file_out)
		File.open(file_out, "w") do |f|
			@conveyors.each { |c| f.puts c.best_direction }
		end
	end

end

f = FileManager.new(ARGV[0])
f.write(ARGV[1])
