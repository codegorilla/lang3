class Model::VariableDecl
  attr_accessor :name, :type, :initializer

  def initialize ()
    @template = Template.make("templates/variableDecl.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
