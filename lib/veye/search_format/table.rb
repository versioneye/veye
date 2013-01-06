require 'terminal-table'

module Veye
  module SearchFormat
    class Table
        def before
            @@table = Terminal::Table.new :heading => %w(index name version product_key)
            @@table.align_column(0, :right)
        end
        def after
            puts @@table.to_s
        end

        def format(result, index)
            row = [index, result["name"], result["version"], result["prod_key"]]
            @@table << row
        end
    end

  end
end
