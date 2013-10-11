module Veye
  module Github
    class GithubInfoJSON
      def before; end
      def after(paging); end

      def format(result)
        puts result.to_json
      end
    end
  end
end

