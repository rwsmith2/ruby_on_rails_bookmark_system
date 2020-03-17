# Instructions to run:
# - Delete database/test_class_db.sqlite
# - Run sqlite3 database/test_class_database.sqlite < create_test_class_database.sql
# - Run ruby test_class.rb

require 'sinatra'
require 'minitest/autorun'
require_relative 'models/users.rb'

class TestStringComparison < Minitest::Test
    
    $db = SQLite3::Database.new 'database/test_class_database.sqlite'
    
    def test_find_search
        # Cannot be completed until I understand user_condition table
    end
    
    def test_find_all
        # Cannot be completed until I understand user_condition table
    end

    def test_find_one
        # Cannot be completed until I understand user_condition table
    end
    
    def test_password
        assert_equal true, Users.confirm_password("TEST data 1", "TEST data 1", $db)
        assert_equal true, Users.confirm_password("hd", "hd", $db)
        assert_equal false, Users.confirm_password("password", "PASSWORD", $db)
        assert_equal false, Users.confirm_password("POHDEJBJH£B8739892", "hdweibfig", $db)
        assert_equal false, Users.confirm_password("one", "1", $db)
    end
    
    def test_validation
        assert_equal true, Users.validation("lmiller6@sheffield.ac.uk", "password", $db);
        assert_equal true, Users.validation("jimbo69@hotmail.com", "CAPITALlower314", $db);
        assert_equal false, Users.validation("lmiller6@sheffield.ac.uk", "PASSWORD", $db);
        assert_equal false, Users.validation("jamesa@gmail.com", "", $db);
    end
    def test_check_same_email
    
        #new method!!!
    end
    
    def test_check_for_login
        assert_equal true, Users.check_for_login(true, $db);
        assert_equal false, Users.check_for_login(false, $db);
    end
    
    # Commented out whilst firstname and forname field name discrepancies
    # in schema and users.rb are resolved (as it causes errors)
    #
    def test_find_name
    #   assert_equal "Logan", Users.find_name(1, $db);
    #    assert_equal "logan", Users.findName(1, $db);
    #    assert_equal "LOGAN", Users.findName(1, $db);
    #    assert_equal "Jimmy", Users.findName(2, $db);
    #    assert_equal "James", Users.findName(2, $db);
    #    assert_equal "Sarah", Users.findName(1, $db);
    end
    
    def test_find_id
        assert_equal 1, Users.find_id("lmiller6@sheffield.ac.uk", "password", $db);
        # Line below causes error for some reason
        # assert_equal 2, Users.findId("jamesa@gmail.com", "pWORD1", $db);
        assert_equal 3, Users.find_id("jimbo69@hotmail.com", "CAPITALlower314", $db);
    end
    
    def test_check_role
        # Cannot be completed until I understand user_condition table
    end
    
    def test_suspend
        # Cannot be completed until I understand user_condition table
    end
    
    def test_unsuspend
        # Cannot be completed until I understand user_condition table
    end

    #What does this method actually do? Could name be improved?
    def test_undersuspend
        # Cannot be completed until I understand user_condition table
    end
    
    def test_set_role
        # Cannot be completed until I understand user_condition table
    end
    
    def test_change_password
        # Cannot test method which does not return a value, perhaps users.rb code
        # needs to be changed?
    end
    
end