module Veye
  module Project
    class ProjectLicenceJSON
      def before; end
      def after; end

      def format(results)
        printf("%s\n", {"licences" => results["licenses"]}.to_json)
      end
    end
  end
end
