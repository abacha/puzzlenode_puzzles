#!/usr/bin/ruby
require 'rubygems'
require 'ap'
require 'pry'

class Piece

	@@board = Array.new(8).map! { Array.new(8) }

	attr_reader :valid_moves, :row, :column, :side, :king

	def initialize(color, column, row)
		@side = (color == "w") ? 1 : -1
		@column = column
		@row = row
		@valid_moves = []
		@@board[column][row] = self
	end

	def setKing
		@@board.flatten.each do |piece|
			if (piece.instance_of? King) && piece.side == @side
				@king = piece
			end
		end
	end

	def move?(column, row, range = 0)
		if @king == nil
			setKing
		end

		if column >= @@board.size || row >= @@board[0].size || column < 0 || row < 0 ||
			(column == @column && row == @row) || (@@board[column][row] != nil && @@board[column][row].side == @side)
			return false
		end

		if range > 0 && !valid_range?(column, row, range)
			return false
		end

		if @valid_moves.empty?
			make_moves
		end

		if !@valid_moves.include?([ column, row ])
			return false
		end

		true
	end

	def valid_range?(column, row, range)
		(@column - column).abs <= range && (@row - row).abs <= range
	end

	def make_moves
		@valid_moves = []
		@@board.flatten.each do |piece|
			if piece != nil
				piece.make_moves
			end
		end
	end

	def self.reset_board
		@@board = Array.new(8).map! { Array.new(8) }
	end

	def self.board
		@@board
	end

	def valid?(move)
		move[0] >= 0 && move[1] >= 0 && move[0] < @@board.size && row < @@board[0].size &&
			(@@board[move[0]][move[1]] == nil || @@board[move[0]][move[1]].side != @side)
	end

	def check_king_under_attack(column, row)
		if @king == nil
			return false
		end
		@@board[@column][@row] = nil
		old = @@board[column][row]
		@@board[column][row] = self
		u_attack = @king.under_attack?
		@@board[@column][@row] = self
		@@board[column][row] = old
		u_attack
	end
end

class King < Piece

	def under_attack?(column = @column, row = @row)
		@@board.flatten.each do |piece|
			if piece != nil && piece.side != @side
				piece.make_moves
				if (piece.instance_of? Pawn) && (column - piece.column).abs == 1 && row == piece.row + 1 * piece.side
					return true
				end
				if piece.valid_moves.include?([ column, row ])
					return true
				end
			end
		end
		false
	end

	def move?(column, row)
		if !super(column, row, 1)
			return false
		end
		!under_attack?(column, row)
	end

	def make_moves
		-1.upto(1) do |x|
			-1.upto(1) do |y|
				@valid_moves << [ @column + x, @row + y ]
			end
		end
		@valid_moves.reject! { |move| !valid?(move) }
	end
end

class Knight < Piece

	def make_moves
		@valid_moves << [@column - 2, @row - 1]
		@valid_moves << [@column - 2, @row + 1]
		@valid_moves << [@column + 2, @row - 1]
		@valid_moves << [@column + 2, @row + 1]
		@valid_moves << [@column - 1, @row - 2]
		@valid_moves << [@column - 1, @row + 2]
		@valid_moves << [@column + 1, @row - 2]
		@valid_moves << [@column + 1, @row + 2]
		@valid_moves.reject! { |move| !valid?(move) }
	end

end

class Pawn < Piece

	def move?(column, row)
		super(column, row, (@row == 1 || @row == 6) ? 2 : 1)
	end

	def make_moves
		@valid_moves << [@column, @row + 1 * @side]

		if @row == 1 || @row == 6
			@valid_moves << [@column, @row + 2 * @side]
		end

		if @column < 7 && @@board[@column + 1][@row + 1 * @side] != nil && @@board[@column + 1][@row + 1 * @side].side != @side
			@valid_moves << [ @column + 1, @row + 1 * @side ]
		end
		if @column > 0 && @@board[@column - 1][@row + 1 * @side] != nil && @@board[@column - 1][@row + 1 * @side].side != @side
			@valid_moves << [ @column - 1, @row + 1 * @side ]
		end
		@valid_moves.reject! { |move| !valid?(move) }
	end

end

class Rook < Piece
	def make_moves
		0.upto(@column - 1) do |x|
			@valid_moves << [ x, @row ]
			break if @@board[x][@row] != nil
		end
		(@column + 1).upto(7) do |x|
			@valid_moves << [ x, @row ]
			break if @@board[x][@row] != nil
		end
		0.upto(@row - 1) do |x|
			@valid_moves << [ @column, x ]
			break if @@board[@column][x] != nil
		end
		(@row + 1).upto(7) do |x|
			@valid_moves << [ @column, x ]
			break if @@board[@column][x] != nil
		end
		@valid_moves.reject! { |move| !valid?(move) }
	end

	def move?(column, row)
		if !super(column, row)
			return false
		end
		!check_king_under_attack(column, row)
	end
end

class Bishop < Piece
	def make_moves
		(7 - [ @column, @row ].max).times do |x|
			@valid_moves << [ @column + x + 1, @row + x + 1 ]
			break if @@board[@column + x + 1][@row + x + 1] != nil
		end
		(8 - [ @column, @row ].max).times do |x|
			@valid_moves << [ @column - x - 1, @row + x + 1 ]
			break if @@board[@column - x - 1][@row + x + 1] != nil
		end

		(7 - @column).times do |x|
			@valid_moves << [ @column + x + 1, @row - x - 1 ]
			break if @@board[@column + x + 1][@row - x - 1] != nil
		end

		([ @column, @row ].max).times do |x|
			@valid_moves << [ @column - x - 1, @row - x - 1 ]
			break if @@board[@column - x - 1][@row - x - 1] != nil
		end
		@valid_moves.reject! { |move| !valid?(move) }
	end

	def move?(column, row)
		if !super(column, row)
			return false
		end
		!check_king_under_attack(column, row)
	end
end

class Queen < Piece
	def make_moves
		color = @side == 1 ? "w" : "b"
		bishop = Bishop.new(color, @column, @row)
		bishop.make_moves
		bishop.valid_moves.each do |m|
			@valid_moves << m
		end
		rook = Rook.new(color, @column, @row)
		rook.make_moves
		rook.valid_moves.each do |m|
			@valid_moves << m
		end
		@valid_moves.uniq!
		@@board[@column][@row] = self
	end

	def move?(column, row)
		if !super(column, row)
			return false
		end
		!check_king_under_attack(column, row)
	end
end

class FileManager

	attr_reader :moves

	def board_to_code(column, row)
		columns = ('a'..'h').to_a
		_column = columns.index(column)
		_row = row.to_i - 1
		return _column, _row
	end
	
	def read_moves(filename)
		@moves = []
		File.open(filename) do |file|
			while line = file.gets
				pos = line.split
				column0, row0 = pos[0].scan(/./)
				column1, row1 = pos[1].scan(/./)
				@moves << [ board_to_code(column0, row0), board_to_code(column1, row1) ]
			end
		end
	end

	def read_board(filename)
		r = 7
		pieces = {
			"B" => Bishop,
			"P" => Pawn,
			"R" => Rook,
			"N" => Knight,
			"K" => King,
			"Q" => Queen
		}
		File.open(filename) do |file|
			while lines = file.gets
				columns = lines.split
				c = 0
				columns.each{ |s|
					if s != "--"
						color, piece = s.scan(/./)
						pieces[piece].new(color, c, r)
					end
					c += 1
				}
				r -= 1
			end
		end
	end

	def write_result(filename)
		File.open(filename, "w") do |f|
			@moves.each do |x|
				piece = x[0]
				pos = x[1]
				if Piece.board[piece[0]][piece[1]] != nil
					f.puts Piece.board[piece[0]][piece[1]].move?(pos[0], pos[1]) ? "LEGAL" : "ILLEGAL"
				else
					f.puts "ILLEGAL"
				end
			end
		end
	end
end

f = FileManager.new
f.read_board(ARGV[0])
f.read_moves(ARGV[1])
f.write_result("result.txt")
