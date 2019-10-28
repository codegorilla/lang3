class Model::ValueDecl
  attr_accessor :name, :type

  def initialize ()
  end

  def render ()
    @template = Template.make("templates/valueDecl.h.erb")
    @template.render(binding)
  end

end
