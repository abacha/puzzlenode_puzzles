require 'test/unit'
require 'spelling.rb'

class SpellingTest < Test::Unit::TestCase

	def test_word
	
		correct = Spelling.correct("remimance", "remembrance", "reminiscence")
		assert_equal("remembrance", correct)
		
		correct = Spelling.correct("inndietlly", "immediately", "incidentally")
		assert_equal("incidentally", correct)
		
		correct = Spelling.correct("millonnir", "millennium", "millionaire")
		assert_equal("millionaire", correct)

		correct = Spelling.correct("consciouss", "conscientious", "consciousness")
		assert_equal("consciousness", correct)		

	end

end
