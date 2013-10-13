require_relative '../base_table.rb'

module Veye
  module User
    class ProfileTable < BaseTable
      def initialize
        headings = %w(username fullname email plan_name, admin, deleted, new_notifications, total_notifications)
        super("User's profile", headings)
      end

      def make_row(profile, index = 0)
        row = [profile['username']]
        row << profile['fullname']
        row << profile['email']
        row << profile['plan_name_id']
        row << profile['admin']
        row << profile['deleted']
        row << profile['notifications']['new']
        row << profile['notifications']['total']
        return row
      end

      def format(results)
        return if results.nil?
        @table << make_row(results)
      end
    end
  end
end

