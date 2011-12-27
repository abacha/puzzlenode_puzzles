require 'rubygems'
require 'pry'
require 'scanf'
class Secret

	def initialize
		@plain = ("A".."Z").to_a
	end

	def shift(t)
		cipher = ("A".."Z").to_a
		0.upto(t-1) { cipher << cipher.shift }
		cipher
	end

	def cesar_decrypt(p_shift, text)
		_text = ""
		cipher = shift(p_shift)
		text.each_char do |c|
			if cipher.index(c)
				_text += @plain[cipher.index(c)]
			else
				_text += c
			end
		end

		_text
	end

	def viginere_decrypt(keyword, text)
		_text = ""
		t = 0
		while t < text.length
			keyword.each_char do |k|
				break if t >= text.length
				_text += cesar_decrypt(@plain.index(k), text[t])
				begin
					t += 1
					break if t >= text.length
					if !text[t].match(/\w/)
						_text += text[t]
					end
				end while !text[t].match(/\w/)
			end
		end
		_text
	end
end


class FileManager

	def initialize(filename)
		keyword = ""
		File.open(filename) do |file|
			@keyword = file.gets
			file.gets
			@text = ""
			while l = file.gets
				@text += l
			end
		end
	end
	
	def get_keyword
		c = 0
		s = Secret.new
		key = 1			
		begin
			c += key.to_i
			puts s.cesar_decrypt(c, @keyword)
			key = STDIN.gets.chomp
		end while key != "0"
		@keyword = s.cesar_decrypt(c, @keyword).chomp
	end

	def write(filename)
		s = Secret.new
		File.open(filename, "w") do |f|
			f.puts s.viginere_decrypt(@keyword, @text)
		end
	end
	
end
f = FileManager.new(ARGV[0]) if ARGV[0] != nil
f.get_keyword
f.write(ARGV[1]) if ARGV[1] != nil
