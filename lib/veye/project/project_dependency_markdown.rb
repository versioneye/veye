module Veye
  module Project
    class ProjectDependencyMarkdown

      @@columns =  %w{index name prod_key version_current version_latest outdated stable}

      def before; end

      def format(results)
        begin
          markdown = "# Dependencies\n\n"
          markdown << @@columns.join(' | ') << "\n"
          markdown << @@columns.map{'---'}.join(' | ') << "\n"

          results = [results] if results.is_a?(Hash)

          results.each_with_index do |result, index|
            row = [index + 1, result["name"], result["prod_key"],
                    result["version_current"], result["version_requested"],
                    result['outdated'] ? 'outdated':'', result['stable'] ? 'stable': 'unstable']
            markdown << row.join(' | ') << "\n"
          end

          puts markdown
        rescue => e
          puts e.backtrace
        end
      end

      def after; end

    end
  end
end

