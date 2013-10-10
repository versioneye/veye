module Veye
  module Github
    class GithubListJSON
      def before
        @@results = {}
      end
      def after(paging = nil)
        @@results[:paging] = paging unless paging.nil?
        puts @@results.to_json
      end

      def format(results)
        results = results.shift if results.is_a? Array
        @@results['repos'] = results['repos']
      end
    end
  end
end

