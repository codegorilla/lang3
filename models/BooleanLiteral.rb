class Model::BooleanLiteral
  attr_accessor :value

  def initialize ()
    @template = Template.make("templates/booleanLiteral.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
