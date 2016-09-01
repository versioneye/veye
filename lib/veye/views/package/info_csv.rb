require_relative '../base_csv.rb'

module Veye
  module Package
    class InfoCSV < BaseCSV
      def initialize
        headers = "name,version,language,prod_key,licence,prod_type,description,link,cves"
        super(headers)
      end
      def format(result)
        vulns = result['security_vulnerabilities'].to_a.map {|x| x['name_id']}.join(';')
        printf("%s,%s,%s,%s,%s,%s,%s,'%s',%s\n",
              result["name"], result["version"], result["language"],
              result["prod_key"], result["license"], result["prod_type"],
              result["link"], result["description"], vulns)
      end
    end
  end
end

