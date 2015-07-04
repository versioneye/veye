require 'test_helper'

class PackageInfoTest < MiniTest::Test
  def setup
    init_environment
  end

  def test_info_api_call
    VCR.use_cassette('package_info') do
      res = Veye::Package::API::get_package('ruby/veye', {})

      assert_equal 200, res.code
      assert_equal true, res.success
      assert_equal "veye", res.data["name"]
      assert_equal "ruby", res.data["language"]
      assert_equal "veye", res.data["prod_key"]
    end
  end

  def test_info_success
    VCR.use_cassette('package_info') do
      output = capture_stdout {|| Veye::Package::Info.get_package('ruby/veye')}
      expected = "\t\e[32m\e[1mveye\e[0m - \e[1m0.0.9\e[0m\n\
\tLanguage       : ruby\n\tLicense        : MIT\n\tProduct type   : RubyGem\n\
\tProduct key    : \e[1mveye\e[0m\n\tDescription    :\n\
\t \n    Veye is commandline tool like Heroku has own ToolBelt, \n\
    and purpose of this tool is to make developer's life even\n\
    more simpler and keep you up-to-date with freshest packages.\n\
  \n\tGroup id       : \n\tLink           : https://github.com/versioneye/veye\n"
      assert_equal expected, output
    end
  end

  def test_info_csv_format
    VCR.use_cassette('package_info') do
      output = capture_stdout {|| Veye::Package::Info.get_package('ruby/veye', {format: 'csv'})}
      expected = "name,version,language,prod_key,licence,prod_type,description,link\n\
veye,0.0.9,ruby,veye,,RubyGem,,\n    Veye is commandline tool like Heroku has own ToolBelt, \n\
    and purpose of this tool is to make developer's life even\n\
    more simpler and keep you up-to-date with freshest packages.\n  \n"
      assert_equal expected, output
    end
  end

  def test_info_json_format
    VCR.use_cassette('package_info') do
      output = capture_stdout {|| Veye::Package::Info.get_package('ruby/veye', {format: 'json'})}
      expected = "{\
\"package\":{\"name\":\"veye\",\"language\":\"ruby\",\"prod_key\":\"veye\",\
\"version\":\"0.0.9\",\"prod_type\":\"RubyGem\",\"group_id\":null,\
\"artifact_id\":null,\"license_info\":\"MIT\",\
\"description\":\"\\n    Veye is commandline tool like Heroku has own ToolBelt, \
\\n    and purpose of this tool is to make developer's life even\
\\n    more simpler and keep you up-to-date with freshest packages.\
\\n  \",\"updated_at\":\"2015-07-04T11:11:15.634Z\",\
\"released_at\":\"2015-07-03T00:00:00.000+00:00\",\
\"dependencies\":[{\"name\":\"rest-client\",\"dep_prod_key\":\"rest-client\",\
\"version\":\"~> 1.6\",\"parsed_version\":\"1.8.0\",\"group_id\":null,\
\"artifact_id\":null,\"scope\":\"runtime\"},{\"name\":\"render-as-markdown\",\
\"dep_prod_key\":\"render-as-markdown\",\"version\":\"~> 0.0\",\
\"parsed_version\":\"0.0.6\",\"group_id\":null,\"artifact_id\":null,\
\"scope\":\"runtime\"},{\"name\":\"terminal-table\",\
\"dep_prod_key\":\"terminal-table\",\"version\":\"~> 1.4\",\
\"parsed_version\":\"1.5.2\",\"group_id\":null,\"artifact_id\":null,\
\"scope\":\"runtime\"},{\"name\":\"rainbow\",\"dep_prod_key\":\"rainbow\",\
\"version\":\"~> 2.0\",\"parsed_version\":\"2.0.0\",\"group_id\":null,\
\"artifact_id\":null,\"scope\":\"runtime\"},{\"name\":\"gli\",\
\"dep_prod_key\":\"gli\",\"version\":\"~> 2.11\",\"parsed_version\":\"2.13.1\",\
\"group_id\":null,\"artifact_id\":null,\"scope\":\"runtime\"},{\"name\":\"awesome_print\",\
\"dep_prod_key\":\"awesome_print\",\"version\":\"~> 1.2\",\"parsed_version\":\"1.6.1\",\
\"group_id\":null,\"artifact_id\":null,\"scope\":\"runtime\"}],\
\"licenses\":[{\"name\":\"MIT\",\"url\":null}],\
\"links\":[{\"name\":\"Homepage\",\"link\":\"https://github.com/versioneye/veye\"},\
{\"name\":\"Project\",\"link\":\"http://rubygems.org/gems/veye\"},\
{\"name\":\"RubyGem Page\",\"link\":\"https://rubygems.org/gems/veye\"}],\
\"archives\":[{\"name\":\"veye-0.0.9.gem\",\"link\":\"https://rubygems.org/gems/veye-0.0.9.gem\"}]}}\n"

      assert_equal expected, output
    end
  end

  def test_info_table_format
    VCR.use_cassette('package_info') do
      output = capture_stdout {|| Veye::Package::Info.get_package('ruby/veye', {format: 'table'})}
      expected = "\
+------+---------+-------------+----------+---------+------------------------------------------------------------------+\n\
|                                                 Package information                                                  |\n\
+------+---------+-------------+----------+---------+------------------------------------------------------------------+\n\
| name | version | product_key | language | license | description                                                      |\n\
+------+---------+-------------+----------+---------+------------------------------------------------------------------+\n\
| veye | 0.0.9   | veye        | ruby     | MIT     |                                                                  |\n\
|      |         |             |          |         |     Veye is commandline tool like Heroku has own ToolBelt,       |\n\
|      |         |             |          |         |     and purpose of this tool is to make developer's life even    |\n\
|      |         |             |          |         |     more simpler and keep you up-to-date with freshest packages. |\n\
|      |         |             |          |         |                                                                  |\n\
+------+---------+-------------+----------+---------+------------------------------------------------------------------+\n"

      assert_equal expected, output
    end
  end
end
