require 'rubygems'
require 'pry'
class Spelling

	def self.correct(search_word, option_0, option_1)
		total = [ 0, 0 ]
		s = 0
		while s < search_word.length
			index = [ 0, 0 ]		
			count = [ 0, 0 ]		
			_word = search_word[s, search_word.length]
			_word.each_char do |c|
				i = option_0.index(c, index[0])
				if i != nil
					index[0] = i
					count[0] += 1
				end

				i = option_1.index(c, index[1])
				if i != nil
					index[1] = i
					count[1] += 1
				end
			end
			total[0] = count[0] if count[0] > total[0]
			total[1] = count[1] if count[1] > total[1]			
			s += 1
		end
		
		total[0] > total[1] ? option_0:option_1
	end
end

class FileManager

	attr_reader :words

	def read(filename)
		@words = Array.new		
		size = 0
		File.open(filename) do |file|
			while line = file.gets
				if line != "\n"
					if size == 0
						size = line.to_i
					else
						@words << Spelling.correct(line, file.gets, file.gets)
					end
				end
			end
		end
	end
	
	def write_result(filename)
		File.open(filename, "w") do |f|
			@words.each do |w|
				f.puts(w)
			end		
		end
	end
end
f = FileManager.new
f.read(ARGV[0])
f.write_result("result.txt")
