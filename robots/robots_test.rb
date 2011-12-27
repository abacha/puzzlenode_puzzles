#!/usr/bin/env ruby -I.
require "test/unit"
require "robots.rb"

class ConveyorTest < Test::Unit::TestCase

	def test_robot_pos
		c = Conveyor.new(nil, nil, "---X----")
		assert_equal(3, c.pos)
	end

	def test_north_west_lasers
		c = Conveyor.new("||#|####", "", "---X----")
		assert_equal(2, c.eval(-1))
	end

	def test_south_west_lasers
		c = Conveyor.new("########", "#|||####", "---X----")
		assert_equal(1, c.eval(-1))
	end

	def test_west_lasers
		c = Conveyor.new("#|#|#|##", "###||###", "---X----")
		assert_equal(2, c.eval(-1))
	end
	
	def test_north_east_lasers
		c = Conveyor.new("||#|####", "########", "---X----")
		assert_equal(1, c.eval(1))
	end

	def test_south_east_lasers
		c = Conveyor.new("########", "#|||##||", "---X----")
		assert_equal(1, c.eval(1))
	end

	def test_east_lasers
		c = Conveyor.new("#|#|#|##", "###||###", "---X----")
		assert_equal(3, c.eval(1))
	end
end
