require 'test_helper'

class UserMeTest < MiniTest::Test
  def setup
    init_environment
    @api_key = "ba7d93beb5de7820764e"
  end

  def test_get_profile_api_call
    VCR.use_cassette('user_get_profile') do
      res = Veye::User::API.get_profile(@api_key, {})
      refute_nil res
      assert_equal 200, res.code
      assert_equal true, res.success
      assert_equal "timgluz", res.data["username"]
      assert_equal "timgluz@gmail.com", res.data["email"]
    end
  end

  def test_get_profile
    VCR.use_cassette('user_get_profile') do
      out = capture_stdout do Veye::User::Me.get_profile(@api_key, {}); end
      expected = "\t\e[32m\e[1mtimgluz\e[0m - \e[1mTim Gluz\e[0m\n\
\tEmail          : timgluz@gmail.com\n\tPlan name      : \n\
\tAdmin          : false\n\tDeleted        : \n\
\tNew notif.s    : \e[1m1\e[0m\n\tTotal notif.s  : 1661\n"

      assert_equal expected, out
    end
  end

  def test_get_profile_csv_format
    VCR.use_cassette('user_get_profile') do
      out = capture_stdout do
        Veye::User::Me.get_profile(@api_key, {format: 'csv'})
      end
      expected = "\
username,fullname,email,plan_name_id,admin,new_notifications,total_notifications\n\
timgluz,Tim Gluz,timgluz@gmail.com,,false,1,1661\n"

      assert_equal expected, out
    end
  end

  def test_get_profile_json_format
    VCR.use_cassette('user_get_profile') do
      out = capture_stdout do
        Veye::User::Me.get_profile(@api_key, {format: 'json'})
      end

      expected = "{\"profile\":{\"fullname\":\"Tim Gluz\",\"username\":\"timgluz\",\
\"email\":\"timgluz@gmail.com\",\"admin\":false,\"deleted_user\":false,\
\"notifications\":{\"new\":1,\"total\":1661},\"enterprise_projects\":1,\"active\":true}}\n"
      assert_equal expected, out
    end
  end

  def test_get_profile_table_format
    VCR.use_cassette('user_get_profile') do
      out = capture_stdout do
        Veye::User::Me.get_profile(@api_key, {format: 'table'})
      end
      expected = "\
+----------+----------+-------------------+------------+--------+----------+--------------------+---------------------+\n\
|                                                   User's profile                                                    |\n\
+----------+----------+-------------------+------------+--------+----------+--------------------+---------------------+\n\
| username | fullname | email             | plan_name, | admin, | deleted, | new_notifications, | total_notifications |\n\
+----------+----------+-------------------+------------+--------+----------+--------------------+---------------------+\n\
| timgluz  | Tim Gluz | timgluz@gmail.com |            | false  |          | 1                  | 1661                |\n\
+----------+----------+-------------------+------------+--------+----------+--------------------+---------------------+\n"
      assert_equal expected, out
    end
  end

  def test_get_favorites_api_call
    VCR.use_cassette("user_get_favorites") do
      res = Veye::User::API.get_favorites(@api_key, {})
      refute_nil res
      assert_equal 200, res.code
      assert_equal true, res.success
      assert_equal "h2", res.data['favorites'].first["name"]
    end
  end

  def test_get_favorites
    VCR.use_cassette("user_get_favorites") do
      out = capture_stdout do
        Veye::User::Me.get_favorites(@api_key, {})
      end
      assert_match /\t\e\[32m\e\[1mh2\e\[0m - \e\[1mcom.h2database\/h2\e\[0m/, out
      assert_match /\tProduct type   : Maven2\n/, out
      assert_match /\tVersion        : \e\[1mMaven2\e\[0m\n/, out
      assert_match /\tLanguage       : java\n/, out
      assert_match /\t\e\[32m\e\[1mmallet\e\[0m - \e\[1mcc.mallet\/mallet\e\[0m\n/, out

    end
  end


  def test_get_favorites_csv_format
    VCR.use_cassette('user_get_favorites') do
      out = capture_stdout do
        Veye::User::Me.get_favorites(@api_key, {format: 'csv'})
      end
      assert_match /\Aindex,name,prod_key,prod_type,version,language\n/, out
      assert_match /h2,com.h2database\/h2,Maven2,1.4.187,java\n/, out
    end
  end

  def test_get_favorites_json_format
    VCR.use_cassette('user_get_favorites') do
      out = capture_stdout do
        Veye::User::Me.get_favorites(@api_key, {format: 'json'})
      end

      assert_match /\"name\":\"h2\"/, out
      assert_match /\"language\":\"java\"/, out
      assert_match /\"prod_key\":\"com.h2database\/h2\"/, out
      assert_match /\"version\":\"1.4.187\"/, out
      assert_match /\"prod_type\":\"Maven2\"/, out
    end
  end

  def test_get_favorites_table_format
    VCR.use_cassette('user_get_favorites') do
      out = capture_stdout do
        Veye::User::Me.get_favorites(@api_key, {format: 'table'})
      end

      rows = out.split(/\n/)
      assert_equal "+----+---------------------------+------------------------------------+-----------------------+----------+", rows[0]
      assert_equal "|                                           Favorite packages                                            |", rows[1]
      assert_equal "+----+---------------------------+------------------------------------+-----------------------+----------+", rows[2]
      assert_equal "| nr | name                      | product_key                        | version               | language |", rows[3]
      assert_equal "+----+---------------------------+------------------------------------+-----------------------+----------+", rows[4]
      assert_equal "| 1  | h2                        | com.h2database/h2                  | 1.4.187               | java     |", rows[5]
    end
  end
end
