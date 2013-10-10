module Veye
  module Github
    class GithubSyncCSV
      def before; end
      def after(paging = nil); end
      def format(results)
        printf("Changed: %s\n", results['changed'])
      end
    end
  end
end

