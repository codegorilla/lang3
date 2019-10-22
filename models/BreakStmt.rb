class Model::BreakStmt

  def initialize ()
  end

  def render ()
    @template = Template.make("templates/breakStmt.c.erb")
    @template.render(binding)
  end

end
