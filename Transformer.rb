require_relative 'models/Model'
require_relative 'models/VariableDecl'
require_relative 'models/Initializer'
require_relative 'models/Type'
require_relative 'Template'

#require 'erb'

class Transformer

  def initialize (root)
    @root = root

    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO
    @logger.info("Initialized code generator.")

    @level = -1

    @label = 0

    # A list of chains
    @chains = []

    # Each chain is a list of instructions
    @chain = []

    # Scope pointer
    @scope = nil

    @globalScope = true
  end
  
  def pushChain ()
    @chains.push(@chain)
    @chain = []
  end

  def popChain ()
    @chain = @chains.pop
  end

  def add (instruction)
    @chain.push(instruction)
  end

  def setLogLevel (level)
    @logger.level = level
  end
  
  def nextLabel ()
    @label += 1
  end

  def globalScope? ()
    @scope.kind == :GLOBAL
  end

  def localScope? ()
    @scope.kind == :LOCAL
  end

  attr_reader :type, :vname

  def start ()
    @logger.debug("start")
    pushChain
    node = @root
    @scope = node.getAttribute("scope")      

    case node.kind
    when :PROGRAM

      for i in 0..node.count-1
        n = node.child(i)
        case n.kind
        when :VARIABLE_DECL
          m = variableDecl(n)
          puts m.render
        when :FUNCTION_DECL
          #t = functionDecl(n)
          #puts t.render
        when :STRUCT_DECL
          #t = structDecl(n)
          # Put this in a new file?
          #puts t.render
        end
      end

    end
  end

  def variableDecl (node)
    @logger.debug("variableDecl")
    m = Model::VariableDecl.new
    m.name = node.child(0).text
    m.type = type(node.child(1))
    m.initializer = initializer(node.child(2))
    m.bake
    m
  end

  def initializer (node)
    m = Model::Initializer.new
    m.bake
    m
  end

  def type (node)
    m = Model::Type.new
    m.name = node.child.text
    m.bake
    m
  end

  # def identifier (node)
  #   @logger.debug("identifier")
  #   n = Node.new(:IDENTIFIER)
  #   n.setLine(node.line)
  #   n.setText(node.text)
  #   n
  # end

  # def type (node)
  #   @logger.debug("type")
  #   n = Node.new(:TYPE)
  #   n
  # end

end #class

