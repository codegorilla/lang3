class Model::EmptyStmt

  def initialize ()
    @template = Template.make("templates/emptyStmt.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
