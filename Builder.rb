require_relative 'models/Model'

require_relative 'models/VariableDecl'
require_relative 'models/Initializer'

require_relative 'models/FunctionDecl'
require_relative 'models/Parameters'
require_relative 'models/Parameter'

require_relative 'models/StructDecl'
require_relative 'models/StructBody'

require_relative 'models/Type'
require_relative 'models/BasicType'

require_relative 'models/BreakStmt'
require_relative 'models/ContinueStmt'
require_relative 'models/EmptyStmt'
require_relative 'models/ExpressionStmt'
require_relative 'models/ReturnStmt'
require_relative 'models/WhileStmt'

require_relative 'models/LogicalOrExpr'
require_relative 'models/LogicalAndExpr'

require_relative 'models/AssignmentExpr'
require_relative 'models/CompoundAssignmentExpr'

require_relative 'models/BinaryExpr'
require_relative 'models/UnaryExpr'
require_relative 'models/BlockExpr'
require_relative 'models/Statement'

require_relative 'models/NullLiteral'
require_relative 'models/BooleanLiteral'
require_relative 'models/IntegerLiteral'
require_relative 'models/FpLiteral'
require_relative 'models/CharacterLiteral'
require_relative 'models/StringLiteral'

require_relative 'models/Name'

require_relative 'Template'

class Builder

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
          m = functionDecl(n)
          puts m.render
        when :STRUCT_DECL
          m = structDecl(n)
          # Put this in a new file?
          puts m.render
        end
      end

    end
  end

  # DECLARATIONS

  def variableDecl (node)
    @logger.debug("variableDecl")
    m = Model::VariableDecl.new
    m.name = name(node.child(0))
    m.type = type(node.child(1))
    m.initializer = initializer(node.child(2))
    m
  end

  def initializer (node)
    @logger.debug("initializer")
    m = Model::Initializer.new
    m.expression = expression(node.child)
    m
  end

  def functionDecl (node)
    @logger.debug("functionDecl")
    m = Model::FunctionDecl.new
    m.name = name(node.child(0))
    m.parameters = parameters(node.child(1))
    m.type = type(node.child(2))
    m.expression = blockExpr(node.child(3))
    # FIX: needs to be a choice between blockExpr or expression
    m
  end

  def parameters (node)
    @logger.debug("parameters")
    m = Model::Parameters.new
    m.params = []
    node.children.each do |n|
      m.params << parameter(n)
    end
    m
  end

  def parameter (node)
    @logger.debug("parameter")
    m = Model::Parameter.new
    m.name = name(node.child(0))
    m.type = type(node.child(1))
    m
  end

  def structDecl (node)
    @logger.debug("structDecl")
    m = Model::StructDecl.new
    m.name = node.child(0).text
    m.body = structBody(node.child(1))
    m
  end

  def structBody (node)
    @logger.debug("structBody")
    @level += 1
    m = Model::StructBody.new
    node.children.each do |n|
      case n.kind
      when :VARIABLE_DECL
        m.fieldElements << fieldElement(n)
      when :FUNCTION_DECL
        m.methodElements << methodElement(n)
      end
    end
    @level -= 1;
    m
  end

  def fieldElement (node)
    @logger.debug("fieldElement")
    case node.kind
    #when :VALUE_DECL    then valueDecl(node)
    when :VARIABLE_DECL then variableDecl(node)
    when :FUNCTION_DECL then functionDecl(node)
    end
  end

  def methodElement (node)
    @logger.debug("methodElement")
    functionDecl(node)
  end


  # TYPES

  def type (node)
    @logger.debug("type")
    m = Model::Type.new
    m.name = basicType(node.child)
    m
  end

  def basicType (node)
    @logger.debug("basicType")
    m = Model::BasicType.new
    m.name = node.text
    m
  end

  # STATEMENTS

  def breakStmt (node)
    @logger.debug("breakStmt")
    Model::BreakStmt.new
  end

  def continueStmt (node)
    @logger.debug("continueStmt")
    Model::ContinueStmt.new
  end

  def emptyStmt (node)
    @logger.debug("emptyStmt")
    Model::EmptyStmt.new
  end

  def expressionStmt (node)
    @logger.debug("expressionStmt")
    m = Model::ExpressionStmt.new
    m.expression = expression(node.child)
    m
  end

  def returnStmt (node)
    @logger.debug("returnStmt")
    Model::ReturnStmt.new(expression(node.child))
  end

  def whileStmt (node)
    @logger.debug("whileStmt")
    m = Model::WhileStmt.new
    m.cond = expression(node.child(0))
    n = node.child(1)
    if n.kind == :BLOCK_EXPR
      m.expression = blockExpr(n)
    else
      m.expression = expression(n)
    end
    m
  end

  # EXPRESSIONS

  def expression (node)
    @logger.debug("expression")
    case node.kind
    when :LOGICAL_OR_EXPR   then logicalOrExpr(node)
    when :LOGICAL_AND_EXPR  then logicalAndExpr(node)
    when :ASSIGNMENT_EXPR   then assignmentExpr(node)
    when :COMPOUND_ASSIGNMENT_EXPR then compoundAssignmentExpr(node)
    when :BINARY_EXPR       then binaryExpr(node)
    when :UNARY_EXPR        then unaryExpr(node)
    #when :BLOCK_EXPR        then blockExpr(node)
    when :NAME              then name(node)
    when :NULL_LITERAL      then nullLiteral(node)
    when :BOOLEAN_LITERAL   then booleanLiteral(node)
    when :INTEGER_LITERAL   then integerLiteral(node)
    when :FP_LITERAL        then fpLiteral(node)
    when :CHARACTER_LITERAL then characterLiteral(node)
    when :STRING_LITERAL    then stringLiteral(node)
    else
      puts node.kind
    end
  end

  def logicalOrExpr (node)
    @logger.debug("logicalOrExpr")
    m = Model::LogicalOrExpr.new
    m.left = expression(node.leftChild)
    m.right = expression(node.rightChild)
    m
  end

  def logicalAndExpr (node)
    @logger.debug("logicalAndExpr")
    m = Model::LogicalAndExpr.new
    m.left = expression(node.leftChild)
    m.right = expression(node.rightChild)
    m
  end

  def assignmentExpr (node)
    @logger.debug("assignmentExpr")
    m = Model::AssignmentExpr.new
    m.left = expression(node.leftChild)
    m.right = expression(node.rightChild)
    m
  end

  def compoundAssignmentExpr (node)
    @logger.debug("compoundAssignmentExpr")
    m = Model::CompoundAssignmentExpr.new
    m.op = node.text
    m.left = expression(node.leftChild)
    m.right = expression(node.rightChild)
    m
  end


  def binaryExpr (node)
    @logger.debug("binaryExpr")
    m = Model::BinaryExpr.new
    m.op = node.text
    m.left = expression(node.leftChild)
    m.right = expression(node.rightChild)
    m
  end

  def unaryExpr (node)
    @logger.debug("unaryExpr")
    m = Model::UnaryExpr.new
    m.op = node.text
    m.expression = expression(node.child)
    m
  end

  def blockExpr (node)
    @logger.debug("blockExpr")
    m = Model::BlockExpr.new
    m.elements = []
    node.children.each do |n|
      m.elements << blockElement(n)
    end
    m
  end

  def blockElement (node)
    @logger.debug("blockElement")
    case node.kind
    #when :VALUE_DECL    then valueDecl(node)
    when :VARIABLE_DECL then variableDecl(node)
    when :BREAK_STMT    then breakStmt(node)
    when :CONTINUE_STMT then continueStmt(node)
    when :EMPTY_STMT    then emptyStmt(node)
    when :RETURN_STMT   then returnStmt(node)
    when :WHILE_STMT    then whileStmt(node)
    else
      expressionStmt(node)
    end
  end  


  # def identifier (node)
  #   @logger.debug("identifier")
  #   n = Node.new(:IDENTIFIER)
  #   n.setLine(node.line)
  #   n.setText(node.text)
  #   n
  # end

  def name (node)
    @logger.debug("name")
    m = Model::Name.new
    m.text = node.text
    m
  end

  # LITERALS

  def nullLiteral (node)
    @logger.debug("nullLiteral")
    Model::NullLiteral.new
  end

  def booleanLiteral (node)
    @logger.debug("booleanLiteral")
    m = Model::BooleanLiteral.new
    m.value = node.text
    m
  end

  def integerLiteral (node)
    @logger.debug("integerLiteral")
    m = Model::IntegerLiteral.new
    m.value = node.text
    m
  end

  def fpLiteral (node)
    @logger.debug("fpLiteral")
    m = Model::FpLiteral.new
    m.value = node.text
    m
  end

  def characterLiteral (node)
    @logger.debug("characterLiteral")
    m = Model::CharacterLiteral.new
    m.value = node.text
    m
  end

  def stringLiteral (node)
    @logger.debug("stringLiteral")
    m = Model::StringLiteral.new
    m.value = node.text
    m
  end

end #class

