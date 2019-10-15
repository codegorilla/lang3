class Model::IfStmt
  attr_accessor :cond, :expression

  def initialize ()
  end

  def render ()
    @template = Template.make("templates/ifStmt.c.erb")
    @template.render(binding)
  end

end
