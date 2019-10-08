class Model::Name
  attr_accessor :text

  def initialize ()
    @template = Template.make("templates/name.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
