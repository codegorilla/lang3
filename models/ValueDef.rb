class Model::ValueDef
  attr_accessor :name, :type, :initializer

  def initialize ()
  end

  def render ()
    @template = Template.make("templates/valueDef.c.erb")
    @template.render(binding)
  end

end
