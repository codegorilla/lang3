class Model::SourceFile
  attr_accessor :elements

  def initialize ()
  end

  def render ()
    @template = Template.make("templates/sourceFile.c.erb")
    @template.render(binding)
  end

end
