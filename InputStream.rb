class InputStream

  def initialize (filename)
    # Read contents of file into buffer
    file = File.new(filename, 'r')
    @buffer = file.read
    file.close
    @pos = 0
  end

  def consume ()
    @pos += 1
  end
  
  def index ()
    @pos
  end

  def lookahead ()
    @buffer[@pos]
  end  
  
end
