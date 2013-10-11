module Veye
  module Github
    class GithubSearchJSON
      def before
        @results = {}
      end
      def after(paging = nil)
        @results[:paging] = paging unless paging.nil?
        puts @results.to_json
      end

      def format(results)
        @results[:results] = results['results']
      end
    end
  end
end

