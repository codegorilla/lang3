class Model::BreakExpr

  def initialize ()
    @template = Template.make("templates/breakExpr.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
