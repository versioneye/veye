module Veye
  module Project
    class ProjectLicenceCSV
      def before
        printf("nr,licence,product keys\n")
      end
      def after; end

      def format(results)
        n = 1
        results["licenses"].each_pair do |licence, prods|
          prod_keys = prods.map {|p| p["prod_key"]}
          printf("%d,%s,%s\n", n, licence, prod_keys.join(','))
          n += 1
        end
      end
    end
  end
end
