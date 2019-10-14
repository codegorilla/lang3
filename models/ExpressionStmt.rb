class Model::ExpressionStmt
  attr_accessor :expression

  def initialize ()
  end

  def render ()
    @template = Template.make("templates/expressionStmt.c.erb")
    @template.render(binding)
  end

end
