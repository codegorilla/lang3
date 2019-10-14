class Model::NullLiteral
  attr_accessor :value

  def initialize ()
    @template = Template.make("templates/nullLiteral.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
