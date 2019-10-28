class Model::FunctionDecl
  attr_accessor :name, :parameters, :type, :block

  def initialize ()
  end

  def render ()
    @template = Template.make("templates/FunctionDecl.h.erb")
    @template.render(binding)
  end

end
