require_relative '../base_pretty.rb'

module Veye
  module Project
    class InfoPretty < BasePretty

      def format(results)
        return if results.nil?
        results = [results] if results.is_a? Hash

        results.each_with_index do |result, index|
          project_name = "#{result['name']}".color(:green).bright
          printf("%3d - %s\n", index + 1, project_name)
          printf("\t%-15s: %s\n", "Project key", "#{result['project_key']}".bright)
          printf("\t%-15s: %s\n", "Project type", result['project_type'])
          printf("\t%-15s: %s\n", "Public", result['public'])
          printf("\t%-15s: %s\n", "Period", result['period'])
          printf("\t%-15s: %s\n", "Source", result['source'])
          printf("\t%-15s: %s\n", "Dependencies", result['dep_number'].to_s.bright)
          printf("\t%-15s: %s\n", "Outdated", result['out_number'].to_s.color(:red))
          printf("\t%-15s: %s\n", "Created", result['created_at'])

        end
      end
    end
  end
end
