require 'rainbow'

module Veye
  module Project
    class CheckPretty
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
                                  "#{result["outdated"]}".foreground(color))

          printf("\t%-15s: %s\n", "Latest version",
                                  result["version_current"].foreground(color))

          printf("\t%-15s: %s\n", "Current version", result["version_requested"])
        
        end
      end
    end
  end
end

