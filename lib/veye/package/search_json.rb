module Veye
  module Package
    class SearchJSON 
      def before
        @results = {:results => []}
      end
      def after(paging = nil)
        @results[:paging] = paging unless paging.nil?
        printf("%s\n", @results.to_json)
      end

      def format(results)
        results.each do |result|
          @results[:results] << result
        end
      end
    end
  end
end
