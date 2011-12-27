#!/usr/bin/ruby
require 'rubygems'
require 'ap'

class Tweet
	attr_reader :sender, :mentions
	
	def initialize(tweetie)
		@mentions = []
		temp = tweetie.scan(/\w+(?=:)/)
		@sender = temp[0]
		temp = tweetie.scan(/(@)(\w+)/)
		temp.each do |m|
			@mentions << m[1]
		end	
	end
	
end

class TweetManager
	
	attr_reader :tweets, :conns
	
	def initialize
		@tweets = Hash.new
		@conns = Hash.new
	end
	
	def create(tweet)
		temp = Tweet.new(tweet)
		mentions = @tweets[temp.sender]
		if (mentions == nil)
			mentions = []
		end
		@tweets[temp.sender] = (temp.mentions + mentions).uniq
		@tweets[temp.sender].sort!
	end
	
	def make_connections
		@tweets.map do |c|
			user = c[0]
			@conns[user] = Array.new
			@conns[user][0] = Array.new			
			c[1].each do |connection|
				if @tweets[connection] != nil && @tweets[connection].include?(user)
					@conns[user][0] << connection
				end
			end	
		end
		@conns.sort
		make_degree_conn(1)
	end
	
	def make_degree_conn(index)
		again = false
		@conns.map do |x|
			user = x[0]
			@conns[user][index] = Array.new
			x[1][index - 1].map do |connection|
				@conns[connection][0].each do |y|
					if !@conns[user].flatten.include?(y) && user != y
						@conns[user][index] << y
						again = true
					end
				end
			end
			@conns[user][index].sort!
		end
		if again == true
			make_degree_conn(index + 1)
		end
	end
end


class FileManager

	def initialize(manager)
		@manager = manager
	end

	def read(filename)
		File.open(filename) do |file|
			while line = file.gets
				@manager.create(line)
			end
		end
	end
	
	def writeResult(filename)
		File.open(filename, "w") do |f|
			@manager.make_connections
			@manager.conns.sort.map do |x|
				f.puts x[0]
				x.each do |y|
					next if y == x[0]
					y.each do |z|
						if z != [ ]
							f.puts z.join(", ")
						end
					end
					f.puts "\n"
				end				
			end		
		end
	end
end
manager = TweetManager.new
f = FileManager.new(manager)
f.read(ARGV[0])
f.writeResult("result.txt")
