class Model::ContinueStmt

  def initialize ()
    @template = Template.make("templates/continueStmt.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
