require_relative '../base_pretty.rb'

module Veye
  module Package
    class InfoPretty < BasePretty
      def format(results)
        result = results
        return if result.nil?

        printf("\t%15s - %s\n", "#{result['name']}".color(:green).bright,
                                "#{result['version'].bright}")
        printf("\t%-15s: %s\n", "Language", result["language"])
        printf("\t%-15s: %s\n", "License", result["license_info"])
        printf("\t%-15s: %s\n", "Product type", result["prod_type"])
        printf("\t%-15s: %s\n", "Product key",
                                "#{result["prod_key"]}".bright)
        printf("\t%-15s:\n\t %s\n", "Description", result["description"])
        printf("\t%-15s: %s\n", 'Group id', result["group_id"])
        printf("\t%-15s: %s\n", 'Link', result["links"].first.fetch('link'))

        vulns = result['security_vulnerabilities'].to_a.map {|x| x['name_id'] }.join(',') 
        printf("\t%-15s: %s\n", 'CVEs', (vulns.empty? ? 'none'.color(:green) : vulns.color(:red)))
      end
    end

  end
end
