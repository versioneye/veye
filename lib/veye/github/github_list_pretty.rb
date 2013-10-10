require 'rainbow'

module Veye
  module Github
    class GithubListPretty
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
        results['repos'].each_with_index {|result, index| print_row(result, index)}
      end

      def print_row(result, index)
        printf(
          "%3d - %s\n",
          index + 1,
          "#{result['name']}".foreground(:green).bright
        )
        printf("\t%-15s: %s\n", "Language",   result['language'])
        printf("\t%-15s: %s\n", "Owner name", result['owner_login'])
        printf("\t%-15s: %s\n", "Owner type", result['owner_type'])
        printf("\t%-15s: %s\n", "Private",    result['private'])
        printf("\t%-15s: %s\n", "Fork",       result['fork'])
        printf("\t%-15s: %s\n", "Branches",   result['branches'].join(','))
        printf("\t%-15s: %s\n", "Description", result['description'])
      end
    end
  end
end
