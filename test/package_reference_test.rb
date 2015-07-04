require 'test_helper'

class PackageReferenceTest < MiniTest::Test
  def setup
    init_environment
  end

  def test_reference_api_call
    VCR.use_cassette('package_reference') do
      res = Veye::Package::API.get_references('ruby/ruby', {})
      refute_nil res
      assert_equal 200, res.code
      assert_equal true, res.success
      assert_equal "acts_as_dasherize_vanity", res.data['results'].first.fetch("name", nil)
    end
  end

  def test_reference_without_results
    VCR.use_cassette('package_reference_empty') do
      output = capture_stdout {|| Veye::Package::References.get_references('ruby/veye', {})}
      expected = "\"\\e[31mNo references for: `ruby/veye`\\e[0m: {\\\"error\\\"=>\\\"Zero references for `Ruby`/`veye`\\\"}\\n\"\n"
      assert_equal expected, output
    end
  end

  def test_reference_with_results
    VCR.use_cassette('package_reference') do
      output = capture_stdout {|| Veye::Package::References.get_references('ruby/ruby', {})}
      expected = "\
  1 - \e[32m\e[1macts_as_dasherize_vanity\e[0m\n\tProduct key    : \e[1macts_as_dasherize_vanity\e[0m\n\
\tProduct type   : RubyGem\n\tLanguage       : ruby\n\tVersion        : \e[1m0.0.3\e[0m\n\
  2 - \e[32m\e[1mblacklisted_password\e[0m\n\tProduct key    : \e[1mblacklisted_password\e[0m\n\
\tProduct type   : RubyGem\n\tLanguage       : ruby\n\tVersion        : \e[1m1.0.0\e[0m\n  3 - \e[32m\e[1mdiamond_shell\e[0m\n\
\tProduct key    : \e[1mdiamond_shell\e[0m\n\tProduct type   : RubyGem\n\tLanguage       : ruby\n\
\tVersion        : \e[1m0.270\e[0m\n  4 - \e[32m\e[1mgitit\e[0m\n\tProduct key    : \e[1mgitit\e[0m\n\
\tProduct type   : RubyGem\n\tLanguage       : ruby\n\tVersion        : \e[1m1.1.0\e[0m\n\
  5 - \e[32m\e[1misaf_id_validator\e[0m\n\tProduct key    : \e[1misaf_id_validator\e[0m\n\
\tProduct type   : RubyGem\n\tLanguage       : ruby\n\tVersion        : \e[1m0.1.0\e[0m\n\
  6 - \e[32m\e[1mmute_updated_at\e[0m\n\tProduct key    : \e[1mmute_updated_at\e[0m\n\
\tProduct type   : RubyGem\n\tLanguage       : ruby\n\tVersion        : \e[1m0.0.2\e[0m\n\
  7 - \e[32m\e[1mpakyow-slim\e[0m\n\tProduct key    : \e[1mpakyow-slim\e[0m\n\
\tProduct type   : RubyGem\n\tLanguage       : ruby\n\tVersion        : \e[1m0.2.2\e[0m\n\
  8 - \e[32m\e[1mscm-workflow\e[0m\n\tProduct key    : \e[1mscm-workflow\e[0m\n\
\tProduct type   : RubyGem\n\tLanguage       : ruby\n\tVersion        : \e[1m0.5.0\e[0m\n\
  9 - \e[32m\e[1msink_utility\e[0m\n\tProduct key    : \e[1msink_utility\e[0m\n\
\tProduct type   : RubyGem\n\tLanguage       : ruby\n\tVersion        : \e[1m0.1.2\e[0m\n"

      assert_equal expected, output
    end
  end

  def test_reference_csv_format
    VCR.use_cassette('package_reference') do
      output = capture_stdout do
        Veye::Package::References.get_references('ruby/ruby', {format: 'csv'})
      end
      expected = "\
nr,name,language,prod_key,prod_type,version\n\
1,acts_as_dasherize_vanity,ruby,acts_as_dasherize_vanity,RubyGem,0.0.3\n\
2,blacklisted_password,ruby,blacklisted_password,RubyGem,1.0.0\n\
3,diamond_shell,ruby,diamond_shell,RubyGem,0.270\n\
4,gitit,ruby,gitit,RubyGem,1.1.0\n\
5,isaf_id_validator,ruby,isaf_id_validator,RubyGem,0.1.0\n\
6,mute_updated_at,ruby,mute_updated_at,RubyGem,0.0.2\n\
7,pakyow-slim,ruby,pakyow-slim,RubyGem,0.2.2\n\
8,scm-workflow,ruby,scm-workflow,RubyGem,0.5.0\n\
9,sink_utility,ruby,sink_utility,RubyGem,0.1.2\n"
      assert_equal expected, output
    end
  end

  def test_reference_json_format
    VCR.use_cassette('package_reference') do
      output = capture_stdout do
        Veye::Package::References.get_references('ruby/ruby', {format: 'json'})
      end
      expected = "{\"results\":[{\"name\":\"acts_as_dasherize_vanity\",\
\"language\":\"ruby\",\"prod_key\":\"acts_as_dasherize_vanity\",\
\"version\":\"0.0.3\",\"prod_type\":\"RubyGem\"},{\"name\":\"blacklisted_password\",\
\"language\":\"ruby\",\"prod_key\":\"blacklisted_password\",\"version\":\"1.0.0\",\
\"prod_type\":\"RubyGem\"},{\"name\":\"diamond_shell\",\"language\":\"ruby\",\
\"prod_key\":\"diamond_shell\",\"version\":\"0.270\",\"prod_type\":\"RubyGem\"},\
{\"name\":\"gitit\",\"language\":\"ruby\",\"prod_key\":\"gitit\",\"version\":\"1.1.0\",\
\"prod_type\":\"RubyGem\"},{\"name\":\"isaf_id_validator\",\"language\":\"ruby\",\
\"prod_key\":\"isaf_id_validator\",\"version\":\"0.1.0\",\"prod_type\":\"RubyGem\"},\
{\"name\":\"mute_updated_at\",\"language\":\"ruby\",\"prod_key\":\"mute_updated_at\",\
\"version\":\"0.0.2\",\"prod_type\":\"RubyGem\"},{\"name\":\"pakyow-slim\",\
\"language\":\"ruby\",\"prod_key\":\"pakyow-slim\",\"version\":\"0.2.2\",\
\"prod_type\":\"RubyGem\"},{\"name\":\"scm-workflow\",\"language\":\"ruby\",\
\"prod_key\":\"scm-workflow\",\"version\":\"0.5.0\",\"prod_type\":\"RubyGem\"},\
{\"name\":\"sink_utility\",\"language\":\"ruby\",\"prod_key\":\"sink_utility\",\
\"version\":\"0.1.2\",\"prod_type\":\"RubyGem\"}]}\n"
      assert_equal expected, output
    end
  end

  def test_reference_table_format
    VCR.use_cassette('package_reference') do
      output = capture_stdout do
        Veye::Package::References.get_references('ruby/ruby', {format: 'table'})
      end

      expected = "\
+-------+--------------------------+---------+--------------------------+--------------+----------+\n\
|                                       Package references                                        |\n\
+-------+--------------------------+---------+--------------------------+--------------+----------+\n\
| index | name                     | version | product_key              | product_type | language |\n\
+-------+--------------------------+---------+--------------------------+--------------+----------+\n\
| 1     | acts_as_dasherize_vanity | 0.0.3   | acts_as_dasherize_vanity | RubyGem      | ruby     |\n\
| 2     | blacklisted_password     | 1.0.0   | blacklisted_password     | RubyGem      | ruby     |\n\
| 3     | diamond_shell            | 0.270   | diamond_shell            | RubyGem      | ruby     |\n\
| 4     | gitit                    | 1.1.0   | gitit                    | RubyGem      | ruby     |\n\
| 5     | isaf_id_validator        | 0.1.0   | isaf_id_validator        | RubyGem      | ruby     |\n\
| 6     | mute_updated_at          | 0.0.2   | mute_updated_at          | RubyGem      | ruby     |\n\
| 7     | pakyow-slim              | 0.2.2   | pakyow-slim              | RubyGem      | ruby     |\n\
| 8     | scm-workflow             | 0.5.0   | scm-workflow             | RubyGem      | ruby     |\n\
| 9     | sink_utility             | 0.1.2   | sink_utility             | RubyGem      | ruby     |\n\
+-------+--------------------------+---------+--------------------------+--------------+----------+\n"

      assert_equal expected, output
    end
  end

end
