class Model::ReturnStmt

  def initialize (expression)
    @expression = expression
  end

  def render ()
    @template = Template.make("templates/returnStmt.c.erb")
    @template.render(binding)
  end

end
