class Model::CharacterLiteral
  attr_accessor :value

  def initialize ()
    @template = Template.make("templates/characterLiteral.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
