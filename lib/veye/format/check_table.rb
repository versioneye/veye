require 'terminal-table'

module Veye
  module Format
    class CheckTable
        def before
          @@table = Terminal::Table.new(
            :heading => %w(index name prod_key version_current version_latest comparator updated_at))
          @@table.align_column(0, :right)
        end

        def after
            puts @@table.to_s
        end

        def format(results)
            results = [results] if results.is_a?(Hash)

            results.each_with_index do |result, index|
                row = [index + 1, result["name"], result["prod_key"], 
                        result["version_current"], result["version_requested"], 
                        result["comparator"], result["updated_at"]]
                @@table << row
            end
        end
    end
  end
end
