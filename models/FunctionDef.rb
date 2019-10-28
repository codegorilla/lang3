class Model::FunctionDef
  attr_accessor :name, :parameters, :type, :block

  def initialize ()
  end

  def render ()
    @template = Template.make("templates/functionDef.c.erb")
    @template.render(binding)
  end

end
