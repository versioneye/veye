require 'terminal-table'

class BaseTable
  def initialize(title, headings)
    @title = title
    @headings = headings
  end

  def before
    @table = Terminal::Table.new :title => @title,
                                 :headings => @headings

    @table.align_column(0, :right)
  end

  def after(paging, allow_pagination = false)
    if allow_pagination && !paging.nil?
      paging_header = ['p', 'current_page', 'per_page', 'total_pages', 'total_entries']
      paging_data = ["p"]
      paging.each_pair do |key, val|
        paging_data << val
      end

      @table.add_separator
      @table << paging_header
      @table << paging_data
    end
    puts @table.to_s
  end

  def format(result)
    raise NotImplementedError
  end
end