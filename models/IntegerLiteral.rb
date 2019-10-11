class Model::IntegerLiteral
  attr_accessor :value

  def initialize ()
    @template = Template.make("templates/integerLiteral.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
