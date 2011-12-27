require 'rubygems'
require 'ap'
require 'bigdecimal'
require 'yajl'
require 'pry'
require 'time'

class Season

	attr_reader :start_date, :end_date, :rate
	include Comparable
	def <=>(other)
		start_date <=> other.start_date
	end

	def initialize(start_date, end_date, rate)
		year = 2011
		@start_date = Time.parse(year.to_s + "-" + start_date)
		@end_date = Time.parse(year.to_s + "-" + end_date)
		if start_date > end_date
			year += 1
			@end_date = Time.parse(year.to_s + "-" + end_date)		
		end
		@rate = BigDecimal.new(rate.to_s)
	end

end

class RentalUnit

	attr_reader :name, :seasons, :cleaning_fee

	def initialize(name, rate, cleaning_fee, seasons)
		@seasons = []
		value = Regexp.new(/\d+\.?\d+/)
		@name = name
		@cleaning_fee = (cleaning_fee != nil) ? cleaning_fee.match(value):0
			
		if seasons == nil
			seasons = []
			seasons[0] = { "one" => { "start" => "01-01", "end" => "12-31", "rate" => rate } }
		end
		seasons.each do |season|
			s = season.to_a[0][1]
			@seasons << Season.new(s['start'], s['end'], s['rate'].match(value))
		end
		@seasons.sort!
	end

	def calculate(start_date, end_date)
		start_date = Time.parse(start_date)
		end_date = Time.parse(end_date)
		total = BigDecimal.new("0")
		@seasons.each do |s|
			if start_date >= s.start_date && start_date < s.end_date
				if end_date <= s.end_date
					days = end_date - start_date
				else
					days = s.end_date - start_date + 86400
					start_date = s.end_date + 86400
				end
				days = BigDecimal.new(days.to_s)
				total += s.rate * days.div(BigDecimal.new("86400"))
			end

		end
		total += BigDecimal.new(@cleaning_fee.to_s) 
		total *= BigDecimal.new("1.0411416")
		sprintf("%.2f", total.round(2).to_f)
	end

end

class FileManager


	def read(filename)
		@units = []
		json = File.new(filename)
		parser = Yajl::Parser.new
		units = parser.parse(json)
		units.each do |u|
			@units << RentalUnit.new(u['name'], u['rate'], u['cleaning fee'], u['seasons'])
		end
	end

	def calculate(filename)
		File.open(filename) do |file|
			line = file.gets
			dates = line.split(" ")
			@units.each do |u|
				puts u.name + ": $" + u.calculate(dates[0], dates[2]).to_s
			end
		end
	end

end

f = FileManager.new
f.read(ARGV[0])
f.calculate(ARGV[1])
