class Model::StructBody
  attr_accessor :fieldElements, :methodElements

  def initialize ()
    @template = Template.make("templates/structBody.c.erb")
    @indent = 1
    @fieldElements = []
    @methodElements = []
  end

  def indent ()
    s = ""
    @indent.times do
      s += "  "
    end
    s
  end

  def render ()
    @template.render(binding)
  end

end
