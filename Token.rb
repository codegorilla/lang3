class Token
  attr_reader :kind, :text, :line, :column

  def initialize (kind, text = nil, line = 0, column = 0)
    @kind = kind
    @text = text
    @line = line
    @column = column
  end

  EOF = Token.new(:EOF)
  UNKNOWN = Token.new(:UNKNOWN)

  def setText (text)
    @text = text
  end

end
