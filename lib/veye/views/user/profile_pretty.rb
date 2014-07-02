require_relative '../base_pretty.rb'

module Veye
  module User
    class ProfilePretty < BasePretty
      def print_row(profile, index = 1)
        printf("\t%15s - %s\n",
               "#{profile['username']}".color(:green).bright,
               "#{profile['fullname'].bright}")
        printf("\t%-15s: %s\n", "Email", profile['email'])
        printf("\t%-15s: %s\n", "Plan name", profile['plan_name_id'])
        printf("\t%-15s: %s\n", "Admin", profile['admin'])
        printf("\t%-15s: %s\n", "Deleted", profile['deleted'])
        printf("\t%-15s: %s\n", "New notif.s",
                                "#{profile['notifications']['new']}".bright)
        printf("\t%-15s: %s\n", "Total notif.s",
                                profile['notifications']['total'])
      end

      def format(results)
        return if results.nil?
        print_row(results)
      end
    end
  end
end

