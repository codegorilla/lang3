class Model::Initializer

  def initialize ()
    @template = Template.make("templates/initializer.c.erb")
  end

  def bake ()
    @template
      .add("expression", 1)
  end

  def render ()
    @template.render
  end

end