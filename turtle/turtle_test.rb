#!/usr/bin/env ruby -I.
require "test/unit"
require "turtle.rb"

class TurtleTest < Test::Unit::TestCase

	def test_canvas_grid
		t = Turtle.new(3)
		assert_equal([ [ ".", ".", "." ], [ ".", "X", "." ], [ ".", ".", "." ] ], t.grid)
		assert_equal([ 1, 1 ], t.pos)
	end

	def test_foward_command
		t = Turtle.new(3)
		t.fd(1)
		assert_equal([ [ ".", "X", "." ], [ ".", "X", "." ], [ ".", ".", "." ] ], t.grid)
	end

	def test_back_command
		t = Turtle.new(3)
		t.bk(1)
		assert_equal([ [ ".", ".", "." ], [ ".", "X", "." ], [ ".", "X", "." ] ], t.grid)
	end

	def test_rt_90
		t = Turtle.new(3)
		t.rt(90)
		t.fd(1)
		assert_equal([ [ ".", ".", "." ], [ ".", "X", "X" ], [ ".", ".", "." ] ], t.grid)
	end

	def test_cross
		t = Turtle.new(3)
		t.fd(1)
		t.bk(1)
		t.lt(90)
		t.fd(1)
		t.bk(1)
		t.lt(90)		
		t.fd(1)
		t.bk(1)		
		t.lt(90)		
		t.fd(1)
		t.bk(1)		
		assert_equal([ [ ".", "X", "." ], [ "X", "X", "X" ], [ ".", "X", "." ] ], t.grid)
	end

	def test_complete_1
		t = Turtle.new(11)
		t.rt(90)
		t.fd(5)
		t.rt(135)
		t.fd(5)
		assert_equal([
			[ ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "." ],
			[ ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "." ],
			[ ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "." ],
			[ ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "." ],
			[ ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "." ],
			[ ".", ".", ".", ".", ".", "X", "X", "X", "X", "X", "X" ],
			[ ".", ".", ".", ".", ".", ".", ".", ".", ".", "X", "." ],
			[ ".", ".", ".", ".", ".", ".", ".", ".", "X", ".", "." ],
			[ ".", ".", ".", ".", ".", ".", ".", "X", ".", ".", "." ],
			[ ".", ".", ".", ".", ".", ".", "X", ".", ".", ".", "." ],
			[ ".", ".", ".", ".", ".", "X", ".", ".", ".", ".", "."] ], t.grid)
	end
end
