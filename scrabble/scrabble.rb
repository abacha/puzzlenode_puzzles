require 'rubygems'
require 'yajl'
require 'pry'
require 'awesome_print'

class Scrabble

  attr_reader :board

  def initialize(board, dictionary, tiles)
    read_board(board)
    read_tiles(tiles)
    read_dictionary(dictionary)
  end

  def read_dictionary(dictionary)
    @dictionary = []
    dictionary.each do |w|
      ok = true
      w.each_char do |c|
        if !@tiles.include? c
          ok = false
          break
        end
      end
      @dictionary << w if ok == true
    end
  end

  def read_tiles(tiles)
    @tiles = {}
    tiles.each do |t|
      @tiles[t[0]] = t[1, t.size].to_i
    end
  end

  def read_board(board)
    @board = Array.new(9).map! { Array.new(12) }
    max = 0
    pos = []
    board.each_with_index do |l,r| 
      l.split.each_with_index do |e,c| 
        if e.to_i > max then max = e.to_i; pos = [ r, c ] end
        @board[r][c] = e.to_i
      end
    end
  end

  def word_score(word, initial, dir)
    pos = initial
    score = 0
    0.upto(word.size - 1) do |i|
      c = word[i]
      return -1 if pos[0] >= @board.size || pos[1] >= @board[0].size
      score += (@board[pos[0]][pos[1]] * @tiles[c])
      pos[0] += dir[0]
      pos[1] += dir[1]
    end
    score
  end

  def best_word
    @max = [0]
    @dictionary.each do |word|
      best_pos(word)
      p @max
    end
    draw_board
  end

  def best_pos(word)
    0.upto(@board.size - 1) do |r|
      0.upto(@board[0].size - word.size) do |c|
        score = word_score(word, [r, c], [0, 1])
        break if score == -1
        @max = [score, [r, c], [0, 1], word] if score > @max[0]
      end
    end
    
    0.upto(@board[0].size - 1) do |c|
      0.upto(@board.size - word.size) do |r|
        score = word_score(word, [r, c], [1, 0])
        break if score == -1
        @max = [score, [r, c], [1, 0], word] if score > @max[0]
      end
    end
  end

  def draw_board
    0.upto(@max[3].size - 1) do |c|
      @board[(@max[1][0] + @max[2][0] * c)][(@max[1][1] + @max[2][1] * c)] = @max[3][c]
    end
  end

end

class FileManager
  
  def read(filename)
    json = File.new(filename)
    parser = Yajl::Parser.new
    input = parser.parse(json)
    Scrabble.new(input["board"], input["dictionary"], input["tiles"])
  end

  def write(board, filename)
    File.open(filename, "w") do |f|
      board.each do |r|
        f.puts r.join(" ")
      end
    end
  end

end
f = FileManager.new
s = f.read(ARGV[0]) if ARGV[0] != nil

s.best_word
f.write(s.board, ARGV[1])
