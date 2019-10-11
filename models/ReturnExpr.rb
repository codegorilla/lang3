class Model::ReturnExpr

  def initialize (expression)
    @expression = expression
  end

  def render ()
    @template = Template.make("templates/returnExpr.c.erb")
    @template.render(binding)
  end

end
