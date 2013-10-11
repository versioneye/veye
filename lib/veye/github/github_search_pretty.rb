require 'rainbow'

module Veye
  module Github
    class GithubSearchPretty
      def before; end
      def after(paging = nil)
        return if paging.nil?
        printf("\n#-- %s\n", "Pagination information".bright)
        printf("\t%-15s: %s\n", "Current page", paging['current_page'])
        printf("\t%-15s: %s\n", "Per page", paging['per_page'])
        printf("\t%-15s: %s\n", "Total pages", paging['total_pages'])
        printf("\t%-15s: %s\n", "Total entries", paging['total_entries'])
      end

      def format(results)
        results['results'].each_with_index do |result, index|
          print_row(result, index)
        end
      end

      def print_row(result, index)
        printf(
          "%3d - %s\n", 
          index + 1,
          "#{result["name"]}".foreground(:green).bright
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

