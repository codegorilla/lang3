class Model::BooleanLiteral
  attr_accessor :value

  def initialize ()
  end

  def render ()
    @template = Template.make("templates/booleanLiteral.c.erb")
    @template.render(binding)
  end

end
