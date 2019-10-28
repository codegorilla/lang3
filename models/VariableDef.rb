class Model::VariableDef
  attr_accessor :name, :type, :initializer

  def initialize ()
    @template = Template.make("templates/variableDef.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
