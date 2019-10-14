class Model::BreakStmt

  def initialize ()
    @template = Template.make("templates/breakStmt.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
