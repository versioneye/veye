module Veye
  module Pagination
    class PaginationJSON
      def before; end
      def after; end

      def format(paging)
        printf("%s\n", {'paging' => paging}.to_json)
      end
    end
  end
end
