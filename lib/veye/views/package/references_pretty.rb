require_relative '../base_pretty.rb'

module Veye
  module Package
    class ReferencesPretty < BasePretty
      def format(results)
        items = results['results']
        return if items.nil?

        items.each_with_index do |result, index|
          printf("%3d - %s\n",
                 index + 1,
                 "#{result["name"]}".color(:green).bright)
          printf("\t%-15s: %s\n", "Product key", result["prod_key"].bright)
          printf("\t%-15s: %s\n", "Product type", "#{result['prod_type']}")
          printf("\t%-15s: %s\n", "Language", result["language"])
          printf("\t%-15s: %s\n", "Version", "#{result['version']}".bright)
       end

      end
    end
  end
end
