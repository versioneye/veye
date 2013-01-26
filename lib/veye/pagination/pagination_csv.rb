module Veye
  module Pagination
    class PaginationCSV
      def before
        printf("current_page,per_page,total_pages,total_entries\n")
      end

      def after; end

      def format(paging)
        printf("%s,%s,%s,%s\n",
              paging['current_page'], paging['per_page'],
              paging['total_pages'], paging['total_entries'])
      end
    end
  end
end
