require 'rainbow'

module Veye
  module Project
    class ProjectListPretty
      def before; end
      def after; end

      def format(results)
        results = [results] if results.is_a? Hash

        results.each_with_index do |result, index|
          project_name = "#{result['name']}".foreground(:green).bright
          printf("%3d - %s\n", index + 1, project_name)
          printf("\t%-15s: %s\n", "Project key", "#{result['project_key']}".bright)
          printf("\t%-15s: %s\n", "Project type", result['project_type'])
          printf("\t%-15s: %s\n", "Private", result['private'])
          printf("\t%-15s: %s\n", "Period", result['period'])
          printf("\t%-15s: %s\n", "Source", result['source'])
          printf("\t%-15s: %s\n", "Dependencies", result['dep_number'])
          printf("\t%-15s: %s\n", "Outdated", result['out_number'])
          printf("\t%-15s: %s\n", "Created", result['created_at'])

        end
      end
    end
  end
end
