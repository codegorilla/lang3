require_relative 'InputStream'
require_relative 'TokenStream'
require_relative 'Lexer'
require_relative 'Parser'
require_relative 'Builder'
require_relative 'Generator'

require 'pp'
require 'logger'

@filename = "input1.ch"
#@filename = "hello.ch"

@logger = Logger.new(STDOUT)
@logger.level = Logger::INFO

#@filename = filename
#@logger = logger

puts "Processing #{@filename}..."

# Build input stream
@logger.info("Building input stream...")
input = InputStream.new(@filename)

# Build token stream
@logger.info("Building token stream...")
lexer = Lexer.new(input)
lexer.setLogLevel(Logger::WARN)
tokens = TokenStream.new(lexer)
puts lexer.problems.errors
puts lexer.problems.warnings

tokens.buffer.each do |i|
  # print "#{i.text} (#{i.line},#{i.column}), "
  print "#{i.text}, "
end
puts ""

# Build AST
@logger.info("Building abstract syntax tree...")
parser = Parser.new(tokens)
parser.setLogLevel(Logger::WARN)
root = parser.start
puts parser.problems.errors
puts parser.problems.warnings

# Build output model
@logger.info("Building output model...")
tx = Builder.new(root)
tx.setLogLevel(Logger::DEBUG)
tx.start


# Build output source file
#gen = Generator.new(root)
#gen.setLogLevel(Logger::DEBUG)
#chain = gen.start

