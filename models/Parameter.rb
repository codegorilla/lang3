class Model::Parameter
  attr_accessor :name, :type

  def initialize ()
    @template = Template.make("templates/parameter.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
