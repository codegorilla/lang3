require_relative 'models/Model'

require_relative 'models/headerFile'
require_relative 'models/SourceFile'

require_relative 'models/ValueDecl'
require_relative 'models/ValueDef'
require_relative 'models/VariableDecl'
require_relative 'models/VariableDef'
require_relative 'models/Initializer'

require_relative 'models/FunctionDecl'
require_relative 'models/FunctionDef'
require_relative 'models/Parameters'
require_relative 'models/Parameter'

require_relative 'models/StructDecl'
require_relative 'models/StructBody'

require_relative 'models/Type'
require_relative 'models/BasicType'

require_relative 'models/Block'

require_relative 'models/Statement'

require_relative 'models/BreakStmt'
require_relative 'models/ContinueStmt'
require_relative 'models/EmptyStmt'
require_relative 'models/ExpressionStmt'
require_relative 'models/IfStmt'
require_relative 'models/ReturnStmt'
require_relative 'models/WhileStmt'

require_relative 'models/LogicalOrExpr'
require_relative 'models/LogicalAndExpr'

require_relative 'models/AssignmentExpr'
require_relative 'models/CompoundAssignmentExpr'

require_relative 'models/BinaryExpr'
require_relative 'models/UnaryExpr'

require_relative 'models/FunctionCall'
require_relative 'models/Arguments'
require_relative 'models/Argument'

require_relative 'models/NullLiteral'
require_relative 'models/BooleanLiteral'
require_relative 'models/IntegerLiteral'
require_relative 'models/FpLiteral'
require_relative 'models/CharacterLiteral'
require_relative 'models/StringLiteral'

require_relative 'models/Name'

require_relative 'Template'

class Builder
  attr_reader :hf, :sf

  def initialize (root)
    @root = root

    # Track header and souce files
    @hf = Model::HeaderFile.new("checker")
    @sf = Model::SourceFile.new("checker")

    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO
    @logger.info("Initialized code generator.")

    @level = -1

    @label = 0

    # Scope pointer
    @scope = nil

    @globalScope = true
  end
  
  def setLogLevel (level)
    @logger.level = level
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
    node = @root
    @scope = node.getAttribute("scope")

    # We aren't going to return a root model here
    # Instead, the roots are simply attributes of the
    # builder that can be accessed through methods

    case node.kind
    when :PROGRAM
      @sf.elements = []
      @hf.elements = []
      node.children.each do |n|
        ma = element(n)
      end
      true
    else
      nil
    end
  end

  def element (node)
    @logger.debug("element")
    case node.kind
    when :VALUE_DECL    then globalValueDecl(node)
    when :VARIABLE_DECL then globalVariableDecl(node)
    when :FUNCTION_DECL then functionDecl(node)
    when :STRUCT_DECL   then structDecl(node)
    end
  end

  # DECLARATIONS

  def globalValueDecl (node)
    @logger.debug("globalValueDecl")
    hm = Model::ValueDecl.new
    hm.name = name(node.child(0))
    hm.type = type(node.child(1))
    @hf.elements << hm
    sm = Model::ValueDef.new
    sm.name = hm.name
    sm.type = hm.type
    sm.initializer = initializer(node.child(2))
    @sf.elements << sm
  end

  def globalVariableDecl (node)
    @logger.debug("globalVariableDecl")
    hm = Model::VariableDecl.new
    hm.name = name(node.child(0))
    hm.type = type(node.child(1))
    @hf.elements << hm
    sm = Model::VariableDef.new
    sm.name = hm.name
    sm.type = hm.type
    sm.initializer = initializer(node.child(2))
    @sf.elements << sm
  end

  def valueDecl (node)
    @logger.debug("valueDecl")
    m = Model::ValueDecl.new
    m.name = name(node.child(0))
    m.type = type(node.child(1))
    m.initializer = initializer(node.child(2))
    m
  end

  def variableDecl (node)
    @logger.debug("variableDecl")
    m = Model::VariableDef.new
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
    hm = Model::FunctionDecl.new
    hm.name = name(node.child(0))
    hm.parameters = parameters(node.child(1))
    hm.type = type(node.child(2))
    @hf.elements << hm
    sm = Model::FunctionDef.new
    sm.name = hm.name
    sm.parameters = hm.parameters
    sm.type = hm.type
    # FIX: needs to be a choice between block or expression
    sm.block = block(node.child(3))
    @sf.elements << sm
    1 # THIS IS A PROBLEM
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
    hm = Model::StructDecl.new
    hm.name = node.child(0).text
    hm.body = structBody(node.child(1))
    @hf.elements << hm

    # Header file needs to contain method declarations
    # Source file needs to contain method definitions
    #@sf.elements << m
  end

  def structBody (node)
    @logger.debug("structBody")
    @level += 1
    m = Model::StructBody.new
    node.children.each do |n|
      case n.kind
      when :VALUE_DECL
        m.fieldElements << fieldElement(n)
      when :VARIABLE_DECL
        m.fieldElements << fieldElement(n)
      when :FUNCTION_DECL
        methodElement(n)
      end
    end
    @level -= 1;
    m
  end

  def fieldElement (node)
    @logger.debug("fieldElement")
    case node.kind
    when :VALUE_DECL    then valueDecl(node)
    when :VARIABLE_DECL then variableDecl(node)
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

  # BLOCK

  def block (node)
    @logger.debug("block")
    m = Model::Block.new
    m.elements = []
    node.children.each do |n|
      m.elements << blockElement(n)
    end
    m
  end

  def blockElement (node)
    @logger.debug("blockElement")
    case node.kind
    when :VALUE_DECL    then valueDecl(node)
    when :VARIABLE_DECL then variableDecl(node)
    when :BREAK_STMT    then breakStmt(node)
    when :CONTINUE_STMT then continueStmt(node)
    when :EMPTY_STMT    then emptyStmt(node)
    when :IF_STMT       then ifStmt(node)
    when :RETURN_STMT   then returnStmt(node)
    when :WHILE_STMT    then whileStmt(node)
    else
      expressionStmt(node)
    end
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

  def ifStmt (node)
    @logger.debug("ifStmt")
    m = Model::IfStmt.new
    m.cond = expression(node.child(0))
    n = node.child(1)
    if n.kind == :BLOCK
      m.expression = block(n)
    else
      m.expression = expression(n)
    end
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
    if n.kind == :BLOCK
      m.expression = block(n)
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
    when :FUNCTION_CALL     then functionCall(node)
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

  def functionCall (node)
    @logger.debug("functionCall")
    m = Model::FunctionCall.new
    m.name = node.child(0).text
    m.arguments = arguments(node.child(1))
    m
  end

  def arguments (node)
    @logger.debug("arguments")
    m = Model::Arguments.new
    m.args = []
    node.children.each do |n|
      m.args << argument(n)
    end
    m
  end

  def argument (node)
    @logger.debug("argument")
    m = Model::Argument.new
    # Not node.child?
    m.expression = expression(node)
    m
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

end # class

