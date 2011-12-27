#!/usr/bin/ruby
require 'test/unit'
require 'chess.rb'

class ChessTest < Test::Unit::TestCase

	def setup
		Piece.reset_board
	end

	def test_white_pawn_move
		pawn = Pawn.new("w", 1, 1)
		move = pawn.move?(1, 2)
		assert(move, "valid move: pawn (1 step)")
		move = pawn.move?(1, 3)
		assert(move, "valid move: pawn (2 steps)")
	end

	def test_pawn_capture
		Rook.new("w", 0, 2)
		Queen.new("w", 2, 1)
		Knight.new("w", 3, 2)
		pawn1 = Pawn.new("w", 1, 1)
		pawn2 = Pawn.new("b", 2, 2)
		move = pawn1.move?(2, 2)
		assert(move, "valid move: pawn (capture)")
		move = pawn2.move?(1, 1)
		assert(move, "valid move: pawn (capture)")
	end

	def test_black_pawn_move
		pawn1 = Pawn.new("b", 6, 6)
		pawn2 = Pawn.new("b", 1, 5)
		Knight.new("w", 0, 4)
		King.new("b", 0, 7)
		assert(pawn1.move?(6, 5), "valid move: pawn 1 step")
		assert(pawn1.move?(6, 4), "valid move: pawn 2 steps")
		assert(pawn2.move?(0, 4), "valid move: pawn (capture)")		
	end


	def test_pawn_invalid_moves
		pawn = Pawn.new("w", 1, 3)
		move = pawn.move?(1, 6)
		assert_equal(false, move, "invalid move: pawn (3 steps)")
		move = pawn.move?(1, 3)
		assert_equal(false, move, "invalid move: pawn (same place)")
		move = pawn.move?(1, 2)
		assert_equal(false, move, "invalid move: pawn (back step)")
		move = pawn.move?(1, 5)
		assert_equal(false, move, "invalid move: pawn (2 steps)")
		move = pawn.move?(0, 4)
		assert_equal(false, move, "invalid move: pawn (diagonal)")
		move = pawn.move?(2, 4)
		assert_equal(false, move, "invalid move: pawn (diagonal)")
		move = pawn.move?(8, 2)
		assert_equal(false, move, "invalid move: pawn (out of board)")
	end

	def test_rook_move_row
		rook = Rook.new("w", 0, 0)
		Bishop.new("b", 0, 5)
		move = rook.move?(0, 1)
		assert(move, "move: rook 1 row steps")
		move = rook.move?(0, 2)
		assert(move, "move: rook 2 row steps")
		move = rook.move?(0, 3)
		assert(move, "move: rook 3 row steps")
		move = rook.move?(0, 5)
		assert(move, "move: rook capture")

		rook = Rook.new("w", 3, 4)
		move = rook.move?(5, 4)
		assert(move, "move: rook 2 row steps")
	end

	def test_rook_move_column
		rook = Rook.new("w", 0, 0)
		move = rook.move?(1, 0)
		assert(move, "move: rook 1 column steps")
		move = rook.move?(3, 0)
		assert(move, "move: rook 3 column steps")
		move = rook.move?(5, 0)
		assert(move, "move: rook 5 column steps")
	end

	def test_rook_invalid_moves
		rook = Rook.new("w", 0, 0)
		Rook.new("w", 0, 6)
		Rook.new("w", 3, 0)
		move = rook.move?(0, 6)
		assert_equal(false, move, "invalid move: rook (other piece)")
		move = rook.move?(0, 7)
		assert_equal(false, move, "invalid move: rook (cant jump)")
		move = rook.move?(0, 0)
		assert_equal(false, move, "invalid move: rook (same place)")
		move = rook.move?(-1, 0)
		assert_equal(false, move, "invalid move: rook (out of board)")
		move = rook.move?(4, 0)
		assert_equal(false, move, "invalid move: rook (cant jump)")
		move = rook.move?(5, 0)
		assert_equal(false, move, "invalid move: rook (cant jump)")
		move = rook.move?(6, 0)
		assert_equal(false, move, "invalid move: rook (cant jump)")
	end


	def test_bishop_move_up
		bishop = Bishop.new("w", 4, 0)
		move = bishop.move?(5, 1)
		assert(move, "valid move: bishop (1 up-right step)")
		move = bishop.move?(6, 2)
		assert(move, "valid move: bishop (2 up-right steps)")
		move = bishop.move?(7, 3)
		assert(move, "valid move: bishop (3 up-right steps)")
		move = bishop.move?(3, 1)
		assert(move, "valid move: bishop (1 up-left step)")
		move = bishop.move?(2, 2)
		assert(move, "valid move: bishop (2 up-left steps)")
		move = bishop.move?(1, 3)
		assert(move, "valid move: bishop (3 up-left steps)")
		move = bishop.move?(0, 4)
		assert(move, "valid move: bishop (4 up-left steps)")
	end

	def test_bishop_move_down
		bishop1 = Bishop.new("w", 4, 5)
		bishop2 = Bishop.new("w", 0, 7)
		assert(bishop1.move?(5, 4), "valid move: bishop (1 down-right step)")
		assert(bishop1.move?(6, 3), "valid move: bishop (2 down-right steps)")
		assert(bishop1.move?(7, 2), "valid move: bishop (3 down-right steps)")
		assert(bishop1.move?(3, 4), "valid move: bishop (1 down-left step)")
		assert(bishop1.move?(2, 3), "valid move: bishop (2 down-left steps)")
		assert(bishop1.move?(1, 2), "valid move: bishop (3 down-left steps)")
		assert(bishop1.move?(0, 1), "valid move: bishop (4 down-left steps)")

		assert(bishop2.move?(1, 6), "valid move: bishop (1 down-right steps)")
		assert(bishop2.move?(2, 5), "valid move: bishop (2 down-right steps)")
		assert(bishop2.move?(3, 4), "valid move: bishop (3 down-right steps)")
		assert(bishop2.move?(4, 3), "valid move: bishop (4 down-right steps)")
		assert(bishop2.move?(5, 2), "valid move: bishop (5 down-right steps)")
		assert(bishop2.move?(6, 1), "valid move: bishop (6 down-right steps)")
		assert(bishop2.move?(7, 0), "valid move: bishop (7 down-right steps)")
	end

	def test_bishop_capture_moves
		bishop = Bishop.new("b", 3, 2)
		Knight.new("w", 5, 4)
		move = bishop.move?(5, 4)
		assert(move, "valid move: bishop (capture)")
	end

	def test_bishop_invalid_moves
		bishop = Bishop.new("w", 4, 0)
		Bishop.new("w", 5, 1)
		move = bishop.move?(6, 2)
		assert_equal(false, move, "invalid move: bishop (cant jump)")
		move = bishop.move?(5, 1)
		assert_equal(false, move, "invalid move: bishop (other piece)")
		move = bishop.move?(4, 0)
		assert_equal(false, move, "invalid move: bishop (same place)")
		move = bishop.move?(6, 0)
		assert_equal(false, move, "invalid move: bishop (same row)")
		move = bishop.move?(4, 2)
		assert_equal(false, move, "invalid move: bishop (same column)")
		move = bishop.move?(8, 10)
		assert_equal(false, move, "invalid move: bishop (out of board)")
	end

	def test_knight_move
		knight = Knight.new("w", 4, 4)
		move = knight.move?(2, 5)
		assert(move, "valid move: knight (c - 2, r + 1)")
		move = knight.move?(6, 5)
		assert(move, "valid move: knight (c + 2, r + 1)")
	end

	def test_knight_invalid_moves
		knight = Knight.new("w", 4, 4)
		Rook.new("w", 2, 5)
		move = knight.move?(6, 6)
		assert_equal(false, move, "invalid move: knight (c + 2, r + 2)")
		move = knight.move?(2, 5)
		assert_equal(false, move, "invalid move: knight (other piece)")
	end

	def test_king_move
		king = King.new("w", 3, 3)
		assert(king.move?(2, 3), "valid move: left")
		assert(king.move?(4, 3), "valid move: right")
		assert(king.move?(3, 4), "valid move: up")
		assert(king.move?(3, 2), "valid move: down")
		assert(king.move?(4, 4), "valid move: up-right")
		assert(king.move?(2, 4), "valid move: up-left")
		assert(king.move?(4, 2), "valid move: down-right")
		assert(king.move?(2, 2), "valid move: down-left")
	end

	def test_king_invalid_moves
		king = King.new("w", 1, 2)
		move = king.move?(1, 4)
		assert_equal(false, move, "invalid move: king (2 steps)")
	end

	def test_king_check_moves_pawn
		king = King.new("b", 1, 2)
		Pawn.new("w", 1, 1)
		move = king.move?(0, 2)
		assert_equal(false, move, "invalid move: check by pawn")
	end

	def test_king_check_moves_rook
		king = King.new("w", 1, 2)
		Rook.new("b", 0, 0)
		move = king.move?(0, 2)
		assert_equal(false, move, "invalid move: check by rook")
	end

	def test_king_check_moves_queen
		king = King.new("w", 1, 2)
		Queen.new("b", 2, 0)
		move = king.move?(2, 2)
		assert_equal(false, move, "invalid move: check by queen")
		move = king.move?(1, 1)
		assert_equal(false, move, "invalid move: check by queen")
	end

	def test_king_check_moves_bishop
		king = King.new("w", 1, 2)
		Bishop.new("b", 2, 4)
		move = king.move?(0, 2)
		assert_equal(false, move, "invalid move: check by bishop")
	end

	def test_king_check_moves_king
		king = King.new("w", 1, 2)
		King.new("b", 3, 2)
		move = king.move?(2, 2)
		assert_equal(false, move, "invalid move: check by king")
	end

	def test_king_check_moves_knight
		king = King.new("w", 1, 2)
		Knight.new("b", 0, 3)
		move = king.move?(1, 1)
		assert_equal(false, move, "invalid move: check by knight")
	end

	def test_king_uncovered_bishop
		King.new("w", 3, 3)
		Bishop.new("b", 1, 1)
		bishop = Bishop.new("w", 2, 2)
		move = bishop.move?(1, 3)
		assert_equal(false, move, "invalid move: king uncovered by bishop")
	end

	def test_king_uncovered_rook
		King.new("w", 3, 3)
		Rook.new("b", 3, 7)
		rook = Rook.new("w", 3, 5)
		move = rook.move?(5, 5)
		assert_equal(false, move, "invalid move: king uncovered by rook")
	end

	def test_king_uncovered_queen
		King.new("w", 3, 3)
		Queen.new("b", 7, 7)
		queen = Queen.new("w", 4, 4)
		move = queen.move?(4, 0)
		assert_equal(false, move, "invalid move: king uncovered by queen")
	end

	def test_queen_rook_move
		queen = Queen.new("w", 5, 4)
		move = queen.move?(3, 4)
		assert(move, "valid move: queen (rook move)")
		move = queen.move?(2, 4)
		assert(move, "valid move: queen (rook move)")
		move = queen.move?(1, 4)
		assert(move, "valid move: queen (rook move)")
		move = queen.move?(5, 2)
		assert(move, "valid move: queen (rook move)")
		move = queen.move?(5, 7)
		assert(move, "valid move: queen (rook move)")
	end

	def test_queen_capture
		queen = Queen.new("w", 5, 4)
		Pawn.new("b", 5, 2)
		Pawn.new("b", 3, 4)
		move = queen.move?(5, 2)
		assert(move, "valid move: queen (rook capture move)")
		move = queen.move?(3, 4)
		assert(move, "valid move: queen (rook capture move)")
	end

	def test_queen_invalid_moves
		queen = Queen.new("w", 5, 4)
		move = queen.move?(1, 2)
		assert_equal(false, move, "invalid move: queen")
		move = queen.move?(3, 3)
		assert_equal(false, move, "invalid move: queen")
		move = queen.move?(2, 6)
		assert_equal(false, move, "invalid move: queen")
		move = queen.move?(5, 4)
		assert_equal(false, move, "invalid move: queen (same place)")
	end

	def test_queen_bishop_move
		queen = Queen.new("w", 5, 4)
		move = queen.move?(3, 6)
		assert(move, "valid move: queen (bishop move)")
		move = queen.move?(6, 5)
		assert(move, "valid move: queen (bishop move)")
		move = queen.move?(2, 1)
		assert(move, "valid move: queen (bishop move)")
		move = queen.move?(7, 2)
		assert(move, "valid move: queen (bishop move)")

		Pawn.new("b", 7, 6)
		move = queen.move?(7, 6)
		assert(move, "valid move: queen (rook bishop move)")
	end
end
