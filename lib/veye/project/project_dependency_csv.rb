module Veye
  module Project
    class ProjectDependencyCSV

      @@columns = %w{nr name prod_key outdated version_current version_requested stable license}

      def before
        puts @@columns.join(',') << "\n"
      end
      def after; end

      def format(results)
        results = [results] if results.is_a?(Hash)

        results.each_with_index do |result, index|
            printf("%d,%s,%s,%s,%s,%s,%s,%s\n",
                   index + 1,
                   result[@@columns[1]],
                   result[@@columns[2]],
                   result[@@columns[3]],
                   result[@@columns[4]],
                   result[@@columns[5]],
                   result[@@columns[6]],
                   result[@@columns[7]]
                 )
        end
      end
    end
  end
end
