module Veye
  module Github
    class GithubSyncJSON
      def before; end
      def after(paging = nil); end
      def format(results)
        puts results.to_json
      end
    end
  end
end

