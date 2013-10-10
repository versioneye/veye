require 'terminal-table'

module Veye
  module Github
    class GithubSyncTable
      @@columns = %w(key value)
      def before
        @@table = Terminal::Table.new :title => "Status of synchronization",
                                      :headings => @@columns
      end

      def after(paging = nil)
        puts @@table.to_s
      end

      def format(results)
        @@table << ["Changed", results['changed']]
      end
    end
  end
end

