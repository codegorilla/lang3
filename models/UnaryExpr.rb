class Model::UnaryExpr
  attr_accessor :op, :expression

  def initialize ()
    @template = Template.make("templates/unaryExpr.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
