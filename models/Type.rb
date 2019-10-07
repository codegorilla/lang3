class Model::Type
  attr_reader :name
  attr_writer :name

  def initialize ()
    @template = Template.make("templates/basicType.c.erb")
  end

  def bake ()
    @template
      .add("name", @name)
  end

  def render ()
    @template.render
  end

end