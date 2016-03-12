require 'test_helper'
require 'csv'

class UserMeTest < Minitest::Test
  def setup
    init_environment
    @api_key = ENV["VEYE_API_KEY"]
  end

  def test_get_profile
    VCR.use_cassette('user_get_profile') do
      out = capture_stdout do Veye::User::Me.get_profile(@api_key, {}); end
      refute_nil out
      rows = out.split(/\n/)
      assert_equal "\t\e[32m\e[1mtimgluz\e[0m - \e[1mTim Gluz\e[0m", rows[0]
      assert_equal "\tEmail          : timgluz@gmail.com", rows[1]
      assert_equal "\tPlan name      : ", rows[2]
      assert_equal "\tAdmin          : false", rows[3]
      assert_equal "\tDeleted        : ", rows[4] 
    end
  end

  def test_get_profile_csv_format
    VCR.use_cassette('user_get_profile') do
      out = capture_stdout do
        Veye::User::Me.get_profile(@api_key, {format: 'csv'})
      end

      refute_nil out
      rows = CSV.parse(out)
      assert_equal ["username", "fullname", "email", "plan_name_id", "admin", "new_notifications", "total_notifications"], rows[0]
      assert_equal ["timgluz", "Tim Gluz", "timgluz@gmail.com", nil, "false", "0", "2467"], rows[1]
    end
  end

  def test_get_profile_json_format
    VCR.use_cassette('user_get_profile') do
      out = capture_stdout do
        Veye::User::Me.get_profile(@api_key, {format: 'json'})
      end
      
      refute_nil out
      dt = JSON.parse(out)
      profile = dt["profile"]
      refute_nil profile, "JSON response has no `profile` field"
      assert_equal "Tim Gluz", profile["fullname"]
      assert_equal "timgluz", profile["username"]
      assert_equal "timgluz@gmail.com", profile["email"]
      assert_equal true, profile["active"]
      assert_equal 0, profile["notifications"]["new"]
    end
  end

  def test_get_profile_table_format
    VCR.use_cassette('user_get_profile') do
      out = capture_stdout do
        Veye::User::Me.get_profile(@api_key, {format: 'table'})
      end
      refute_nil out

      rows = out.split(/\n/)
      assert_match(/\|\s+User\'s profile\s+\|/, rows[1])
      assert_match(
        /\| username \| fullname \| email\s+| plan_name \| admin \| deleted \| new_notifications \| total_notifications \|/,
       rows[3]
      )
      assert_match(/\| timgluz  \| Tim Gluz \| timgluz@gmail.com \|\s+\| false/, rows[5])
    end
  end

  def test_get_favorites
    VCR.use_cassette("user_get_favorites") do
      out = capture_stdout do
        Veye::User::Me.get_favorites(@api_key, {})
      end
      assert_match(/\t\e\[32m\e\[1mh2\e\[0m - \e\[1mcom.h2database\/h2\e\[0m/, out)
      assert_match(/\tProduct type   : Maven2\n/, out)
      assert_match(/\tVersion        : \e\[1mMaven2\e\[0m\n/, out)
      assert_match(/\tLanguage       : java\n/, out)
      assert_match(/\t\e\[32m\e\[1mmallet\e\[0m - \e\[1mcc.mallet\/mallet\e\[0m\n/, out)

    end
  end


  def test_get_favorites_csv_format
    VCR.use_cassette('user_get_favorites') do
      out = capture_stdout do
        Veye::User::Me.get_favorites(@api_key, {format: 'csv'})
      end
      refute_nil out
      rows = CSV.parse out
      assert_equal ["index", "name", "prod_key", "prod_type", "version", "language"], rows[0]
      assert_equal ["1", "h2", "com.h2database/h2", "Maven2", "1.4.191", "java"], rows[1]
      assert_equal ["2", "mallet", "cc.mallet/mallet", "Maven2", "2.0.7", "java"], rows[2]
    end
  end

  def test_get_favorites_json_format
    VCR.use_cassette('user_get_favorites') do
      out = capture_stdout do
        Veye::User::Me.get_favorites(@api_key, {format: 'json'})
      end
      refute_nil out
      dt = JSON.parse out
      fav = dt["favorites"].first
      assert_equal "h2", fav["name"]
      assert_equal "java", fav["language"]
      assert_equal "com.h2database/h2", fav["prod_key"]
      assert_equal "Maven2", fav["prod_type"]
    end
  end

  def test_get_favorites_table_format
    VCR.use_cassette('user_get_favorites') do
      out = capture_stdout do
        Veye::User::Me.get_favorites(@api_key, {format: 'table'})
      end
      refute_nil out
      rows = out.split(/\n/)
      assert_match(/\|\s+Favorite packages\s+\|/, rows[1])
      assert_match(/\| nr \| name\s+\| product_key\s+\| version\s+\| language\s+\|/, rows[3])
      assert_match(/\| 1\s+\| h2\s+\| com\.h2database\/h2\s+\| 1\.4\.191\s+\| java\s+\|/ , rows[5])
    end
  end
end
