module Veye
  module User
    class ProfileCSV
      def before
        printf("index,username,fullname,email,plan_name_id,admin,new_notifications,total_notifications\n")
      end
      def after; end

      def format(results)
        results = [results] if results.is_a? Hash

        results.each_with_index do |result, index|
          printf("%d,%s,%s,%s,%s,%s,%s,%s\n",
                index + 1, result['username'], result['fullname'], result['email'],
                result['plan_name_id'], result['admin'], 
                result['notifications']['new'],result['notifications']['total'])
        end
      end
    end
  end
end
