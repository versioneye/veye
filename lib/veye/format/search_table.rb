require 'terminal-table'

module Veye
  module Format
    class SearchTable
        def before
            @@table = Terminal::Table.new :title => "Package search",
                                          :headings => %w(index name version product_key)
            @@table.align_column(0, :right)
        end
        def after
            puts @@table.to_s
        end

        def format(results)
            results.each_with_index do |result, index|
                row = [index+1, result["name"], result["version"], result["prod_key"]]
                @@table << row
            end
        end
    end

  end
end
