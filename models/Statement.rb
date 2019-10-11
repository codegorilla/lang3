class Model::Statement
  attr_accessor :expression

  def initialize ()
    @template = Template.make("templates/statement.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
