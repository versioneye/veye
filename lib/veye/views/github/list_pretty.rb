require_relative '../base_pretty.rb'

module Veye
  module Github
    class ListPretty < BasePretty
      def format(results)
        results['repos'].each_with_index {|result, index| print_row(result, index)}
      end

      def print_row(result, index)
        printf(
          "%3d - %s\n",
          index + 1,
          "#{result['name']}".color(:green).bright
        )
        printf("\t%-15s: %s\n", "Language",   result['language'])
        printf("\t%-15s: %s\n", "Owner name", result['owner_login'])
        printf("\t%-15s: %s\n", "Owner type", result['owner_type'])
        printf("\t%-15s: %s\n", "Private",    result['private'])
        printf("\t%-15s: %s\n", "Fork",       result['fork'])
        printf("\t%-15s: %s\n", "Branches",   result['branches'].join(','))
        printf("\t%-15s: %s\n", "Description", result['description'])
        printf("\t%-15s: %s\n", "Imported", result['imported_projects'].join(','))
      end
    end
  end
end
