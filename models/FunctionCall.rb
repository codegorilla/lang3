class Model::FunctionCall
  attr_accessor :name, :arguments

  def initialize ()
  end

  def render ()
    @template = Template.make("templates/functionCall.c.erb")
    @template.render(binding)
  end

end
