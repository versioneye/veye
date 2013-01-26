module Veye
  module User
    class ProfileJSON
      def before; end
      def after; end
      
      def format(results)
        results = [results] if results.is_a? Hash
        printf("%s\n", {"profiles" => results}.to_json)
      end
    end
  end
end

