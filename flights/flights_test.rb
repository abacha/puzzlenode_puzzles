require 'test/unit'
require 'flights.rb'

class FlightsTest < Test::Unit::TestCase

	def setup
		@manager = FlightManager.new
	end

#	def test_invalid_flights
#		@manager.create(0, "A Z 09:00 10:00 100.00")
#		assert_equal(1, @manager.flights[0].size)
#		@manager.create(0, "Z A 09:00 10:00 100.00")		
#		assert_equal(1, @manager.flights[0].size)
#		@manager.create(0, "A Z 10:00 09:00 100.00")		
#		assert_equal(1, @manager.flights[0].size)				
#	end

	def test_cheapest_1
		@manager.create(0, "A Z 09:00 10:00 100.00")
		@manager.create(0, "A Z 09:00 10:00 150.00")
		@manager.create(0, "A Z 09:00 10:00 350.00")
		flight = @manager.cheapest(0)
		assert_equal("09:00 10:00 100.00", flight)
	end

	def test_cheapest_2
		@manager.create(0, "C Z 10:00 11:00 100.00")
		@manager.create(0, "A C 09:00 10:00 100.00")		
		@manager.create(0, "C Z 10:00 11:00 150.00")
		@manager.create(0, "C Z 09:00 11:00 50.00")
		flight = @manager.cheapest(0)
		assert_equal("09:00 11:00 200.00", flight)
	end
end

