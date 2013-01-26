require 'rainbow'

module Veye
  module User
    class ProfilePretty
      def before; end
      def after; end

      def show_profile(profile, index)
        printf("\t%15s - %s\n",
               "#{profile['username']}".foreground(:green).bright,
               "#{profile['fullname'].bright}")
        puts "\t-------------------------"
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
        results = [results] if results.is_a? Hash
        results.each_with_index {|profile, index| show_profile(profile, index)}
      end
    end
  end
end

