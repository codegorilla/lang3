class Model::FunctionDecl
  attr_accessor :name, :parameters, :type, :block

  def initialize ()
  end

  def render ()
    @template = Template.make("templates/functionDecl.c.erb")
    @template.render(binding)
  end

end
