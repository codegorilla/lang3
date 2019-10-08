class Model::Type
  attr_accessor :name

  def initialize ()
    @template = Template.make("templates/type.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
