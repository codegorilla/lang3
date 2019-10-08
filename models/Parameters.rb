class Model::Parameters
  attr_accessor :params

  def initialize ()
    @template = Template.make("templates/parameters.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
