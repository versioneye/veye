require 'terminal-table'

module Veye
  module User
    class ProfileTable
      def before
        @@table = Terminal::Table.new :title => "User's profile",
                                      :headings => %w(nr username fullname email plan_name, admin, deleted, new_notifications, total_notifications)

        @@table.align_column(0, :right)
      end

      def after
        puts @@table.to_s
      end

      def make_row(profile, index)
        row = [index + 1, profile['username'], profile['fullname'], profile['email']]
        row << profile['plan_name_id']
        row << profile['admin']
        row << profile['deleted']
        row << profile['notifications']['new']
        row << profile['notifications']['total']
        return row
      end

      def format(results)
        results = [results] if results.is_a? Hash
        results.each_with_index {|profile, index| @@table << make_row(profile, index)}
      end
    end
  end
end

