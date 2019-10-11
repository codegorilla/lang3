class Model::FunctionDecl
  attr_accessor :name, :parameters, :type, :expression

  def initialize ()
    @template = Template.make("templates/functionDecl.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
