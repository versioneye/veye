module Veye
  module Project
    class ProjectListJSON
      def before; end
      def after; end

      def format(results)
        printf("%s\n", {"projects" => results}.to_json)
      end
    end
  end
end

