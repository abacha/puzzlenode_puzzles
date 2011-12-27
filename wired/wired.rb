require 'rubygems'
require 'pry'
require 'ap'

class Circuit
end

class FileManager

	attr_reader :circuits

	def initialize
		@circuits = []
	end

	def read(filename)
		_circuit = []
		File.open(filename) do |file|
			while line = file.gets
				if line != "\n"
					_circuit << line
				else
					@circuits << Circuit.new(_circuit)
					_circuit = []
				end
			end
			@circuits << Circuit.new(_circuit)
		end
	end
end

class Circuit

	attr_reader :text, :circuit

	def initialize(text)
		@finish = nil
		@text = text
		@circuit = []
		@ports = [ "O", "A", "N", "X" ]
		@input = Regexp.new(/\d-+/)
		@_input = Regexp.new(/[ ]+\d-*/)		
		@port = Regexp.new(/ +[OANX]-*/)
		@output = Regexp.new(/\d-+@/)
		read_circuit
	end

	def read_circuit
		limit1 = 1 << 32
		@text.each_with_index do |line, r|
			next if line == nil || line == ""
			if line[0, limit1].match(@output)
				@finish = line[/\d/]
				break
			elsif line[0, limit1].match(@input)
				@circuit[r] = line[0, limit1][/\d/] == "1"
				limit1 = line.index("|") + 1
			elsif line[0, limit1].match(@port)
				@circuit[r] = line[0, limit1][/[OANX]/]
			elsif line[0, limit1].match(@_input)
				@text[r][limit1] = line[0, limit1][/\d/]
			end
			@text[r] = line[limit1, line.length]
			@text[r] = nil if @text[r] == "\n"
		end
		return @finish if @finish != nil		
		eval_ports
		read_circuit
	end

	def eval_ports
		@circuit.each_with_index do |line, i|
			if @ports.include? line
				v0 = v1 = nil
				p = line
				i.downto(0) do |c|
					if @circuit[c] == true || @circuit[c] == false
						v0 = @circuit[c]
						@circuit[c] = nil
						break
					end
				end
				if p != "N"
					(i+1).upto(@circuit.size) do |c|
						if @circuit[c] == false || @circuit[c] == true
							v1 = @circuit[c]
							@circuit[c] = nil
							break
						end
					end
				end
				@text[i][0] = ((v0 | v1) ? "1" : "0") if line == "O"
				@text[i][0] = ((v0 & v1) ? "1" : "0") if line == "A"
				@text[i][0] = ((v0 ^ v1) ? "1" : "0") if line == "X"
				@text[i][0] = ((!v0) ? "1" : "0") if line == "N"
			end
		end
	end

	def eval
		@finish == "1" ? "on":"off"
	end
end

f = FileManager.new
f.read(ARGV[0])
f.circuits.each do |x|
	puts x.eval
end
