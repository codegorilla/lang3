class Model::Argument
  attr_accessor :expression

  def initialize ()
  end

  def render ()
    @template = Template.make("templates/argument.c.erb")
    @template.render(binding)
  end

end
