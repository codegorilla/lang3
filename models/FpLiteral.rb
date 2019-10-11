class Model::FpLiteral
  attr_accessor :value

  def initialize ()
    @template = Template.make("templates/fpLiteral.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
