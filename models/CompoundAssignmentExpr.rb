class Model::CompoundAssignmentExpr
  attr_accessor :op, :left, :right

  def initialize ()
    @template = Template.make("templates/compoundAssignmentExpr.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
