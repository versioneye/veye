module Veye
  module Github
    class GithubSearchCSV
      @@columns = %q[nr,name,language,owner_name,owner_type,private,fork,watchers,forks,git_url]
      def before
        printf("%s\n", @@columns)
      end
      def after(paging = nil)
        return if paging.nil?

        printf("# ------------------------------------------\n")
        printf("current_page,per_page,total_pages,total_entries\n")
        printf("%s,%s,%s,%s\n",
              paging['current_page'],
              paging['per_page'],
              paging['total_pages'],
              paging['total_entries'])
      end

      def format(results)
        results['results'].each_with_index do |result, index|
          print_row(result, index)
        end
      end

      def print_row(result, index)
        printf("%d,%s,%s,%s,%s,%s,%s,%s,%s,%s\n",
                index + 1,
                result['name'],
                result['language'],
                result['owner_name'],
                result['owner_type'],
                result['private'],
                result['fork'],
                result['watchers'],
                result['forks'],
                result['git_url']
              )
      end
    end
  end
end

