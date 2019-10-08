class Model::BasicType
  attr_accessor :name

  def initialize ()
    @template = Template.make("templates/basicType.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
