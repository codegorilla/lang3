class Model::VariableDecl
  attr_reader :name, :type, :initializer
  attr_writer :name, :type, :initializer

  def initialize ()
    @template = Template.make("templates/variableDecl.c.erb")
  end

  def bake ()
    @template
      .add("name", @name)
      .add("type", @type)
      .add("initializer", @initializer)
  end

  def render ()
    @template.render
  end

end
