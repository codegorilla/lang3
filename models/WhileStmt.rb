class Model::WhileStmt
  attr_accessor :cond, :expression

  def initialize ()
  end

  def render ()
    @template = Template.make("templates/whileStmt.c.erb")
    @template.render(binding)
  end

end
