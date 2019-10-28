class Model::HeaderFile
  attr_accessor :elements

  def initialize (name)
    @name = name
  end

  def render ()
    @template = Template.make("templates/headerFile.h.erb")
    @template.render(binding)
  end

end
