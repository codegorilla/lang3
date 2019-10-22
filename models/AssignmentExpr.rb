class Model::AssignmentExpr
  attr_accessor :left, :right

  def initialize ()
  end

  def render ()
    @template = Template.make("templates/assignmentExpr.c.erb")
    @template.render(binding)
  end

end
