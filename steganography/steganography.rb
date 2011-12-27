require "rubygems"
require "pry"
class FileManager

  def initialize(filename)
    File.open(filename) do |f|
      read_header(f)
    end
  end
  
  def read_header(f)
      prefix = f.read(2)
      size = f.read(4).unpack("<l")
      p "size=" + size.to_s
      r1 = f.read(2).unpack("<l")
      r2 = f.read(2).unpack("<l")
      offset = f.read(4).unpack("<l")
      header_size = f.read(4).unpack("L")
      width = f.read(4).unpack("l")
      p "width=" + width.to_s
      height = f.read(4).unpack("l")
      p "height=" + height.to_s
      nplanes = f.read(2).unpack("S")
      bitspp = f.read(2).unpack("S")
      compress_type = f.read(4).unpack("L")
      p "compress_type=" + compress_type.to_s
      bmp_bytesz = f.read(4).unpack("L")
      hres = f.read(4).unpack("l")
      vres = f.read(4).unpack("l")
      ncolors = f.read(4).unpack("L")
      nimpcolors = f.read(4).unpack("L")
      
      binding.pry
  end

end
f = FileManager.new(ARGV[0])
