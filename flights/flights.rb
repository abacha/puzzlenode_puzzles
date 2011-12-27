require 'rubygems'
require 'time'
require 'ap'
require 'pry'


class Graph

	# Constructor

	def initialize
		@g = {}	 # the graph // {node => { edge1 => weight, edge2 => weight}, node2 => ...
		@nodes = Array.new		 
		@INFINITY = 1 << 64 	 
	end
		
	def add_edge(s,t,w) 		# s= source, t= target, w= weight
		if (not @g.has_key?(s))	 
			@g[s] = {t=>w}		 
		else
			@g[s][t] = w         
		end
		
		# Begin code for non directed graph (inserts the other edge too)
		
		if (not @g.has_key?(t))
			@g[t] = {s=>w}
		else
			@g[t][s] = w
		end

		# End code for non directed graph (ie. deleteme if you want it directed)

		if (not @nodes.include?(s))	
			@nodes << s
		end
		if (not @nodes.include?(t))
			@nodes << t
		end	
	end
	
	# based of wikipedia's pseudocode: http://en.wikipedia.org/wiki/Dijkstra's_algorithm
	
	def dijkstra(s)
		@d = {}
		@prev = {}

		@nodes.each do |i|
			@d[i] = @INFINITY
			@prev[i] = -1
		end	

		@d[s] = 0
		q = @nodes.compact
		while (q.size > 0)
			u = nil;
			q.each do |min|
				if (not u) or (@d[min] and @d[min] < @d[u])
					u = min
				end
			end
			if (@d[u] == @INFINITY)
				break
			end
			q = q - [u]
			@g[u].keys.each do |v|
				alt = @d[u] + @g[u][v]
				if (alt < @d[v])
					@d[v] = alt
					@prev[v]  = u
				end
			end
		end
	end
	
	# To print the full shortest route to a node
	
	def print_path(dest)
		if @prev[dest] != -1
			print_path @prev[dest]
		end
		print "\n>#{dest}"
	end
	
	# Gets all shortests paths using dijkstra
	
	def shortest_paths(s)
		@source = s
		dijkstra s
		#puts "Source: #{@source}"
		@nodes.each do |dest|
			#puts "Target: #{dest}"
			print_path dest
			if @d[dest] != @INFINITY
				#puts "Distance: #{@d[dest]}"
			end
		end
	end
end

class Flight

	attr_reader :arrival, :departure, :cost, :from, :to, :length

	def initialize(from, to, departure, arrival, cost)
		@from = from
		@to = to
		@cost = cost
		@arrival = arrival
		@departure = departure
		@length = Time.parse(arrival) - Time.parse(departure)
	end

end

class FlightManager
	
	attr_reader :flights
	
	def initialize
		@flights = []
	end

	def create(f, schedule)
		schedule = schedule.split(" ")
		if schedule[0] < schedule[1] && schedule[2] < schedule[3]
			@flights[f] = [] if @flights[f] == nil
			@flights[f] << Flight.new(schedule[0], schedule[1], schedule[2], schedule[3], schedule[4])
		end

	end
	
	def cheapest(f)
		gr = Graph.new
		@flights[f].each do |x|
			gr.add_edge(x.from, x.to, x.cost)		
		end
		ap gr.shortest_paths("A")
		ap gr.print_path("Z")
	end
end

class FileManager

	def initialize(manager)
		@manager = manager
	end

	def read(filename)
		f = 0
		File.open(filename) do |file|
			file.gets
			file.gets
			flights_to_read = file.gets.to_i
			c = 0
			while line = file.gets
				if line != "\n"
					if c < flights_to_read
						@manager.create(f, line)
						c += 1
					else
						flights_to_read = line.to_i
						c = 0
						f += 1
					end
				end
			end
		end
	end
end

manager = FlightManager.new

f = FileManager.new(manager)
f.read("sample-input.txt")
