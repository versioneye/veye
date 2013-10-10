require 'rainbow'

module Veye
  module Github
    class GithubSyncPretty
      def before; end
      def after(paging = nil); end
      def format(results)
        state = "#{results['changed']}"
        if results['changed']
          state = state.foreground(:green)
        else
          state = state.foreground(:red)
        end
        printf("Changed: %s\n", state)
      end
    end
  end
end

