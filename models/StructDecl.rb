class Model::StructDecl
  attr_accessor :name, :body

  def initialize ()
    @template = Template.make("templates/structDecl.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
