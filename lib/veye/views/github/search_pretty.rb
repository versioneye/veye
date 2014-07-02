require_relative '../base_pretty.rb'

module Veye
  module Github
    class SearchPretty < BasePretty
      def format(results)
        results['results'].each_with_index do |result, index|
          print_row(result, index)
        end
      end

      def print_row(result, index)
        printf(
          "%3d - %s\n",
          index + 1,
          "#{result["name"]}".color(:green).bright
        )
        printf("\t%-15s: %s\n", 'language', result['language'])
        printf("\t%-15s: %s\n", 'owner_name', result['owner_name'])
        printf("\t%-15s: %s\n", 'owner_type', result['owner_type'])
        printf("\t%-15s: %s\n", 'private', result['private'])
        printf("\t%-15s: %s\n", 'fork', result['fork'])
        printf("\t%-15s: %s\n", 'watchers', result['watchers'])
        printf("\t%-15s: %s\n", 'forks', result['forks'])
        printf("\t%-15s: %s\n", 'git_url', result['git_url'])

      end
    end
  end
end

