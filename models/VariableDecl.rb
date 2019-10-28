class Model::VariableDecl
  attr_accessor :name, :type

  def initialize ()
    @template = Template.make("templates/variableDecl.h.erb")
  end

  def render ()
    @template.render(binding)
  end

end
