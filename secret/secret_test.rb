#!/usr/bin/env ruby -I.
require "test/unit"
require "secret.rb"

class SecretTest < Test::Unit::TestCase

	def setup
		@s = Secret.new
	end

	def test_cesar_cipher
		t = @s.cesar_decrypt(3, "FRZDUGV GLH PDQB WLPHV EHIRUH WKHLU GHDWKV; WKH YDOLDQW QHYHU WDVWH RI GHDWK EXW RQFH.")
		assert_equal("COWARDS DIE MANY TIMES BEFORE THEIR DEATHS; THE VALIANT NEVER TASTE OF DEATH BUT ONCE.", t)
	end
	
	def test_viginere_cipher
		t = @s.viginere_decrypt("GARDEN", "IONDVQY DZH QNTY KLQRY BVISEK TYHME JERWLF")
		assert_equal("COWARDS DIE MANY TIMES BEFORE THEIR DEATHS", t)
	end
	
	def test_viginere_cipher_big
		t = @s.viginere_decrypt("GARDEN", "IONDVQY DZH QNTY KLQRY BVISEK TYHME JERWLF; ZHV YEYOAEW RRBEI WEFZE FI HRGTY EYG UNTH. SS GLC WLR COEGIEY TYDX V EEK KEIK HVDVQ, OT JHIZY TF PI ZUSK VXEGNXH XUGT DHR FNOLOH SKAI; VIRONX WLNZ DVDXU, G NVFIFYAIB IAJ, WZOP PUMV ZLRT IK ZMYR CFPI.")
		assert_equal("COWARDS DIE MANY TIMES BEFORE THEIR DEATHS; THE VALIANT NEVER TASTE OF DEATH BUT ONCE. OF ALL THE WONDERS THAT I YET HAVE HEARD, IT SEEMS TO ME MOST STRANGE THAT MEN SHOULD FEAR; SEEING THAT DEATH, A NECESSARY END, WILL COME WHEN IT WILL COME.", t)
	end	
	
end
