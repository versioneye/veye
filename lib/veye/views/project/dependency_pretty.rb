require_relative '../base_pretty.rb'

module Veye
  module Project
    class DependencyPretty < BasePretty
      def format(results)
        return if results.nil?
        results = [results] if results.is_a?(Hash)
        results.each_with_index do |result, index|
          project_name = "#{result['name']}".color(:green).bright
          printf("%3d - %s\n", index + 1, project_name)
          printf("\t%-15s: %s\n", "Product key", result["prod_key"])

          color_code = (result["outdated"] == true) ? :red : :green
          printf("\t%-15s: %s\n", "Outdated",
                                  "#{result['outdated']}".color(color_code))

          printf("\t%-15s: %s\n", "Current version",
                                  "#{result['version_current']}".color(color_code))

          printf("\t%-15s: %s\n", "Requested version", result["version_requested"])
          printf("\t%-15s: %s\n", "License", result["license"])

        end
      end
    end
  end
end

