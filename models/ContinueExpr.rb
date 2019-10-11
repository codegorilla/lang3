class Model::ContinueExpr

  def initialize ()
    @template = Template.make("templates/continueExpr.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
