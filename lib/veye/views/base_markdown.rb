require 'render-as-markdown'

class BaseMarkdown
  def initialize(title, headings)
    @title = title
    @columns = headings
    @markdown = "# #{@title}\n\n"
    @table = RenderAsMarkdown::Table.new @columns
  end
  def before; end

  def after(paging = nil, allow_pagination = false)
    @markdown << @table.render
    @markdown << "\n\n"
    puts @markdown
  end
end