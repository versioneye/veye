require 'rainbow'

module Veye
  module Project
    class ProjectDependencyPretty
      def before; end
      def after; end

      def format(results)
        results = [results] if results.is_a?(Hash)
        results.each_with_index do |result, index|
          project_name = "#{result['name']}".foreground(:green).bright
          printf("%3d - %s\n", index + 1, project_name)
          printf("\t%-15s: %s\n", "Product key", result["prod_key"])
          
          color = (result["outdated"] == true) ? :red : :green
          printf("\t%-15s: %s\n", "Outdated",
                                  "#{result['outdated']}".foreground(color))

          printf("\t%-15s: %s\n", "Current version",
                                  "#{result['version_current']}".foreground(color))

          printf("\t%-15s: %s\n", "Requested version", result["version_requested"])
          printf("\t%-15s: %s\n", "License", result["license"])
       
        end
      end
    end
  end
end

