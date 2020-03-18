# Instructions to run:
# - Delete database/test_class_db.sqlite
# - Run sqlite3 database/test_class_database.sqlite < create_test_class_database.sql
# - Run ruby test_class.rb
# 
# - You must follow these steps everytime to ensure test data has not been changed

require 'sinatra'
require 'minitest/autorun'
require_relative 'models/users.rb'

class TestStringComparison < Minitest::Test
    
    $db = SQLite3::Database.new 'database/test_class_database.sqlite'
    
    # Compares methods returned hash values by outputting methods to console and checking this output
    # (assert_equal currently not working for hash values)
    def test_find_search
        assert_output(//, '') do
            setup_test_find_search("");
        end
        assert_output(/{:id=>1, :firstname=>\"Logan\", :surname=>\"Miller\", :access_level=>\"admin\", :suspended=>0}\n/, '') do
            setup_test_find_search("LOGAN");
        end
        assert_output(/{:id=>1, :firstname=>\"Logan\", :surname=>\"Miller\", :access_level=>\"admin\", :suspended=>0}\n/, '') do
            setup_test_find_search("logan");
        end
         assert_output(/{:id=>1, :firstname=>\"Logan\", :surname=>\"Miller\", :access_level=>\"admin\", :suspended=>0}\n/, '') do
            setup_test_find_search("oga");
        end   
    end

    # Outputs result of Users.find_all so that the returned hash value can be checked
    # (assert_equal currently not working for hash values)
    def setup_test_find_search(search)
        puts Users.find_search(search, $db);
    end
    
    # Compares methods returned hash value by outputting method to console and checking this output
    # (assert_equal currently not working for hash values)
    def test_find_all
        assert_output(/{:id=>1, :firstname=>\"Logan\", :surname=>\"Miller\", :access_level=>\"admin\", :suspended=>0}\n{:id=>2, :firstname=>\"James\", :surname=>\"Acaster\", :access_level=>\"employee\", :suspended=>0}\n{:id=>3, :firstname=>\"Jimmy\", :surname=>\"Carr\", :access_level=>\"registered\", :suspended=>1}\n/, '') do
            setup_test_find_all;
        end
    end
    
    # Outputs result of Users.find_all so that the returned hash value can be checked
    # (assert_equal currently not working for hash values)
    def setup_test_find_all 
        puts Users.find_all($db);
    end

    # Compares methods returned hash value by outputting method to console and checking this output
    # (assert_equal currently not working for hash values)
    def test_find_one
        assert_output(/{:id=>1, :firstname=>\"Logan\", :surname=>\"Miller\", :email=>\"lmiller6@sheffield.ac.uk\", :phone=>\"07123456789\", :password=>\"password", :access_level=>"admin"}/, '') do
            setup_test_find_one;
        end
    end
        
    # Outputs result of Users.find_one so that the returned hash value can be checked
    # (assert_equal currently not working for hash values)
    def setup_test_find_one
        puts Users.find_one(1, $db);
    end
    
    # Users.new test missing as you cannot check if new has been created without the new being given an id
    
    def test_confirm_password
        assert_equal true, Users.confirm_password("TEST data 1", "TEST data 1", $db)
        assert_equal true, Users.confirm_password("hd", "hd", $db)
        assert_equal false, Users.confirm_password("password", "PASSWORD", $db)
        assert_equal false, Users.confirm_password("POHDEJBJH£B8739892", "hdweibfig", $db)
        assert_equal false, Users.confirm_password("one", "1", $db)
    end
    
    def test_check_same_email
        assert_equal false, Users.check_same_email("unusedemail@email.com", $db);
        assert_equal true, Users.check_same_email("lmiller6@sheffield.ac.uk", $db);
    end
    
    def test_validation
        assert_equal true, Users.validation("lmiller6@sheffield.ac.uk", "password", $db);
        assert_equal true, Users.validation("jimbo69@hotmail.com", "CAPITALlower314", $db);
        assert_equal false, Users.validation("lmiller6@sheffield.ac.uk", "PASSWORD", $db);
        assert_equal false, Users.validation("jamesa@gmail.com", "", $db);
    end

    
    def test_check_for_login
        assert_equal true, Users.check_for_login(true, $db);
        assert_equal false, Users.check_for_login(false, $db);
    end
    
    def test_find_name
        assert_equal "Logan", Users.find_name(1, $db);
        assert_equal "James", Users.find_name(2, $db);
        assert_equal "Jimmy", Users.find_name(3, $db);
    end
    
    def test_find_id
        assert_equal 1, Users.find_id("lmiller6@sheffield.ac.uk", "password", $db);
        assert_equal 2, Users.find_id("jamesa@gmail.com", "pWORD1", $db);
        assert_equal 3, Users.find_id("jimbo69@hotmail.com", "CAPITALlower314", $db);
    end
    
    
    def test_check_role
        assert_equal "admin", Users.check_role(1, $db);
        assert_equal "employee", Users.check_role(2, $db);
        assert_equal "registered", Users.check_role(3, $db);
    end
    
    # Cannot fully test method with Mini Test as it does not return value, so simply testing
    # if it returns nothing (as is expected)
    def test_suspend
        assert_equal [], Users.suspend(2, $db);
        assert_equal [], Users.suspend(3, $db);
        
        # Change test data back to original form
        assert_equal [], Users.unsuspend(2, $db);
    end
    
    # Cannot fully test method with Mini Test as it does not return value, so simply testing
    # if it returns nothing (as is expected)
    def test_unsuspend
        assert_equal [], Users.unsuspend(2, $db);
        assert_equal [], Users.unsuspend(3, $db);    
        
        # Change test data back to original form
        assert_equal [], Users.suspend(3, $db);
    end

    def test_undersuspend
        assert_equal true, Users.under_suspend(3, $db);
        assert_equal false, Users.under_suspend(1, $db);
    end
    
    # Cannot fully test method with Mini Test as it does not return value, so simply testing
    # if it returns nothing (as is expected)
    def test_set_role
        assert_equal [], Users.set_role("admin", 2, $db);
        assert_equal [], Users.set_role("employee", 1, $db);
        
        # Change test data back to original form
        assert_equal [], Users.set_role("employee", 2, $db);
        assert_equal [], Users.set_role("admin", 1, $db);
    end
    
    # Cannot fully test method with Mini Test as it does not return value, so simply testing
    # if it returns nothing (as is expected)
    def test_change_password
        assert_equal [], Users.change_password("new password", 2, $db);
        assert_equal [], Users.change_password("UPPERhelloW0r1D! ", 3, $db);
        
        # Change test data back to original form
        assert_equal [], Users.change_password("pWORD1", 2, $db);
        assert_equal [], Users.change_password("CAPITALlower314", 3, $db);
        
    end
    
end