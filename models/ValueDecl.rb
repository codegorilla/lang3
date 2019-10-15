class Model::ValueDecl
  attr_accessor :name, :type, :initializer

  def initialize ()
  end

  def render ()
    @template = Template.make("templates/valueDecl.c.erb")
    @template.render(binding)
  end

end
