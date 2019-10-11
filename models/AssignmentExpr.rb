class Model::AssignmentExpr
  attr_accessor :left, :right

  def initialize ()
    @template = Template.make("templates/assignmentExpr.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
