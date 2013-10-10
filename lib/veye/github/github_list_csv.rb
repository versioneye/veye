module Veye
  module Github
    class GithubListCSV
      def before
        printf("nr,fullname,language,owner_login,owner_type,private,fork,branches,description")
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
        results['repos'].each_with_index do |result, index|
          printf("%d,%s,%s,%s,%s,%s,%s,%s,%s\n",
                index + 1,
                result['fullname'],
                result['language'],
                result['owner_login'],
                result['owner_type'],
                result['private'],
                result['fork'],
                result['branches'].join('|'),
                result['description']
                )
        end
      end
    end
  end
end
