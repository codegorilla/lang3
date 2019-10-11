class Model::Initializer
  attr_accessor :expression

  def initialize ()
    @template = Template.make("templates/initializer.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end