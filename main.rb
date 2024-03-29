require_relative 'InputStream'
require_relative 'TokenStream'
require_relative 'Lexer'
require_relative 'Parser'
require_relative 'Builder'

require 'pp'
require 'logger'

@filename = ARGV[0]

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
parser.setLogLevel(Logger::INFO)
root = parser.start
puts parser.problems.errors
puts parser.problems.warnings

# Build output model
# @logger.info("Building output header model...")
# hb = HeaderBuilder.new(root)
# hb.setLogLevel(Logger::INFO)
# model = hb.start
# puts model.render

@logger.info("Building output model...")
builder = Builder.new(root)
builder.setLogLevel(Logger::INFO)
model = builder.start

puts builder.hf.render
puts builder.sf.render

#puts model.render

