class Node
  attr_reader :children, :kind, :line, :text

  def initialize (kind, text = nil)
    @children = []
    @kind = kind
    @text = text

    # This is a test about associating some token information with the node
    # Might delete this field
    @line = 0

    # Syntesized attributes
    @attributes = {}
  end

  NULL_LITERAL = Node.new(:NULL_LITERAL, "null")
  UNIT_LITERAL = Node.new(:UNIT_LITERAL, "()")

  # Test about associating token info with node
  # Might delete this method
  def setLine (line)
    @line = line
  end
  
  def setText (text)
    @text = text
  end
  
  def addChild (node)
    @children.push(node)
  end

  def child (n = 0)
    @children[n]
  end

  def leftChild ()
    @children[0]
  end

  def rightChild ()
    @children[1]
  end

  def count ()
    @children.size
  end

  def setAttribute (name, value)
    @attributes[name] = value
  end

  def getAttribute (name)
    @attributes[name]
  end

end

