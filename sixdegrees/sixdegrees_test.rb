#!/usr/bin/ruby
require 'test/unit'
require 'sixdegrees.rb'

class TweetTest < Test::Unit::TestCase

	def test_sender
		t = Tweet.new("bob: @alberta hey ya")
		assert_equal("bob", t.sender, "sender should be bob")
	end
	
	def test_one_mention
		t = Tweet.new("bob: @alberta hey ya")
		assert_equal([ "alberta" ], t.mentions, "mention should be alberta")
	end
	
	def test_multiple_mentions
		t = Tweet.new("bob: @alberta, @laura hey ya")
		assert_equal([ "alberta", "laura" ], t.mentions, "mention should be alberta and laura")
		t = Tweet.new("bob: @alberta, @laura, @adriano hey ya")
		assert_equal([ "alberta", "laura", "adriano" ], t.mentions, "mention should be alberta and laura")
	end
	
	def test_manager_create_one_user
		manager = TweetManager.new

		manager.create("bob: @alberta, hey ya")
		assert_equal(manager.tweets.size, 1, "should have 1 user")
		assert_equal(manager.tweets['bob'].size, 1, "should have 1 mention")

		manager.create("bob: @alberta, hey ya")
		assert_equal(manager.tweets.size, 1, "should have 1 user")
		assert_equal(manager.tweets['bob'].size, 1, "should have 1 mention")


		manager.create("bob: @alberta, @laura hey ya")
		assert_equal(manager.tweets.size, 1, "should have 1 user")
		assert_equal(manager.tweets['bob'].size, 2, "should have 2 mentions")
	end
	
	
	def test_manager_create_two_users
		manager = TweetManager.new

		manager.create("bob: @alberta, hey ya")
		manager.create("alberta: hey! @laura")

		assert_equal(manager.tweets.size, 2, "should have 2 users")
		assert_equal(manager.tweets['bob'].size, 1, "should have 1 mention")
		assert_equal(manager.tweets['alberta'].size, 1, "should have 1 mention")		
	end
	

	def populate(manager)
		manager.create("alberta: @bob \"It is remarkable, the character of the pleasure we derive from the best books.\"")
		manager.create("bob: \"They impress us ever with the conviction that one nature wrote and the same reads.\" /cc @alberta")
		manager.create("alberta: hey @christie. what will we be reading at the book club meeting tonight?")
		manager.create("christie: 'Every day, men and women, conversing, beholding and beholden.' /cc @alberta, @bob")
		manager.create("bob: @duncan, @christie so I see it is Emerson tonight")
		manager.create("duncan: We'll also discuss Emerson's friendship with Walt Whitman /cc @bob")
		manager.create("alberta: @duncan, hope you're bringing those peanut butter chocolate cookies again :D")
		manager.create("emily: Unfortunately, I won't be able to make it this time /cc @duncan")
		manager.create("duncan: @emily, oh what a pity. I'll fill you in next week.")
		manager.create("christie: @emily, \"Books are the best of things, well used; abused, among the worst.\" -- Emerson")
		manager.create("emily: Ain't that the truth ... /cc @christie")
		manager.create("duncan: hey @farid, can you pick up some of those cookies on your way home?")
		manager.create("farid: @duncan, might have to work late tonight, but I'll try and get away if I can")
	end

	def test_manager
		manager = TweetManager.new
		populate(manager)
		
		assert_equal(manager.tweets.size, 6, "should have 6 users")
		assert_equal([ 'bob', 'christie', 'duncan' ], manager.tweets['alberta'], "should have 2 mentions")
		assert_equal([ 'alberta', 'christie', 'duncan' ], manager.tweets['bob'], "should have 3 mentions")
		assert_equal([ 'alberta', 'bob', 'emily' ], manager.tweets['christie'], "should have 3 mentions")
		assert_equal([ 'bob', 'emily', 'farid' ], manager.tweets['duncan'], "should have 3 mentions")						
	end
	
	def test_first_connections
		manager = TweetManager.new
		populate(manager)
		manager.make_connections
		assert_equal( [ 'bob', 'christie' ], manager.conns['alberta'][0], "should have 2 first degree connections")
		assert_equal( [ 'alberta', 'christie', 'duncan' ], manager.conns['bob'][0], "should have 3 first degree connections")
		assert_equal( [ 'alberta', 'bob', 'emily' ], manager.conns['christie'][0], "should have 3 first degree connection")
		assert_equal( [ 'bob', 'emily', 'farid' ], manager.conns['duncan'][0], "should have 3 first degree connections")
		assert_equal( [ 'alberta', 'bob', 'emily' ], manager.conns['christie'][0], "should have 2 first degree connections")
		assert_equal( [ 'duncan' ], manager.conns['farid'][0], "should have 1 first degree connection")				

	end
	
	def test_second_connections
		manager = TweetManager.new
		populate(manager)
		manager.make_connections
		assert_equal( [ 'duncan', 'emily' ], manager.conns['alberta'][1], "should have 3 second degree connection")
		assert_equal( [ 'emily', 'farid' ], manager.conns['bob'][1], "should have 3 second degree connection")
		assert_equal( [ 'duncan' ], manager.conns['christie'][1], "should have 3 second degree connection")
		assert_equal( [ 'alberta', 'christie' ], manager.conns['duncan'][1], "should have 3 second degree connection")
		assert_equal( [ 'alberta', 'bob', 'farid' ], manager.conns['emily'][1], "should have 3 second degree connection")
		assert_equal( [ 'bob', 'emily' ], manager.conns['farid'][1], "should have 2 second degree connection")		
	end
	
	def test_third_connections
		manager = TweetManager.new
		populate(manager)
		manager.make_connections
		assert_equal( [ 'farid' ], manager.conns['alberta'][2], "alberta should have 1 third degree connection")
		assert_equal( [ 'farid' ], manager.conns['christie'][2], "christie should have 1 third degree connection")
		assert_equal( [ 'alberta', 'christie' ], manager.conns['farid'][2], "farid should have 2 third degree connection")		
	end

end
