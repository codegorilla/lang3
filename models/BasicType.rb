class Model::BasicType
  attr_accessor :name

  def initialize ()
  end

  def render ()
    @template = Template.make("templates/basicType.c.erb")
    @template.render(binding)
  end

end
