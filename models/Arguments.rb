class Model::Arguments
  attr_accessor :args

  def initialize ()
  end

  def render ()
    @template = Template.make("templates/arguments.c.erb")
    @template.render(binding)
  end

end
