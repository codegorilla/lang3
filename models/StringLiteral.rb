class Model::StringLiteral
  attr_accessor :value

  def initialize ()
    @template = Template.make("templates/stringLiteral.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
