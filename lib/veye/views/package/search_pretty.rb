require_relative '../base_pretty.rb'

module Veye
  module Package
    class SearchPretty < BasePretty
      def format(results)
        items = results['results']
        return if items.nil?

        items.each_with_index do |result, index|
          printf("%3d - %s\n",
                 index + 1,
                 "#{result["name"]}".color(:green).bright)
          printf("\t%-15s: %s\n", "Product key", result["prod_key"])
          printf("\t%-15s: %s\n", "Latest version",
                 "#{result["version"]}".color(:green).bright)
          printf("\t%-15s: %s\n", "Language", result["language"])

          if result.has_key? "group_id" and not result["group_id"].empty?
            printf("\t%-15s: %s\n", "Group id", result["group_id"])
          end
        end
      end
    end
  end
end
