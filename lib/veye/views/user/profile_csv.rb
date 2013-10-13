require_relative '../base_csv.rb'

module Veye
  module User
    class ProfileCSV < BaseCSV
      def initialize
        headers = "username,fullname,email,plan_name_id,admin,new_notifications,total_notifications"
        super(headers)
      end
      def format(results)
        return nil if results.nil?
        printf("%s,%s,%s,%s,%s,%s,%s\n",
              results['username'],
              results['fullname'],
              results['email'],
              results['plan_name_id'],
              results['admin'],
              results['notifications']['new'],
              results['notifications']['total'])
      end
    end
  end
end
