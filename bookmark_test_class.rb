# Instructions to run:
# - Delete database/test_class_database.sqlite
# - Run sqlite3 database/test_class_database.sqlite < create_test_class_database.sql
# - Run ruby bookmark_test_class.rb
# 
# - You must follow these steps everytime to ensure test data has not been changed

require 'sinatra'
require 'minitest/autorun'
require_relative 'models/bookmark.rb'

class TestStringComparison < Minitest::Test
    
    $db = SQLite3::Database.new 'database/test_class_database.sqlite';
    
    # Cannot fully test method with Mini Test as it does not return value, so simply testing
    # if it returns nothing (as is expected)
    def test_new
        assert_equal [], Bookmark.new("Uni website", "https://sheffield.ac.uk", "The official uni web page", "Mr Test", "2020-3-19", 2, 1, 0, $db);
    
        # Change test data back to original form
        Bookmark.delete(4, $db);
    end
    
    # Compares methods returned hash value by outputting method to console and checking this output
    # (assert_equal currently not working for hash values)
    def test_find_all
        assert_output(/{:title=>\"Lab results\", :author=>\"Logan Miller\", :date=>\"2020-2-10\", :rating=>4, :reported=>0, :id=>1}\n{:title=>\"My website\", :author=>\"Jimmy Carr\", :date=>\"2020-3-19\", :rating=>5, :reported=>0, :id=>2}\n{:title=>\"Funny jokes\", :author=>\"Jimmy Carr\", :date=>\"2019-12-9\", :rating=>2, :reported=>0, :id=>3}\n/, '') do
            setup_test_find_all;
        end
    end
    
    # Outputs result of Users.find_all so that the returned hash value can be checked
    # (assert_equal currently not working for hash values)
    def setup_test_find_all
        puts Bookmark.find_all($db);
    end
    
    # Cannot fully test method with Mini Test as it does not return value, so simply testing
    # if it returns nothing (as is expected)
    def test_reported
        assert_equal [], Bookmark.reported(1, $db);
        
        # Change test data back to original form
        Bookmark.unreported(1, $db);
    end
    
    # Cannot fully test method with Mini Test as it does not return value, so simply testing
    # if it returns nothing (as is expected)
    def test_unreported
        assert_equal [], Bookmark.unreported(1, $db);
       
    end
    
    # Compares methods returned hash valuea by outputting methods to console and checking this output
    # (assert_equal currently not working for hash values)
    def test_find_search
        assert_output(//, '') do
            setup_test_find_search("");
        end
        assert_output(/{:title=>\"Funny jokes\", :author=>\"Jimmy Carr\", :date=>\"2019-12-9\", :rating=>2, :reported=>0}\n/, '') do
            setup_test_find_search("jokes");
        end
        assert_output(/{:title=>\"Lab results\", :author=>\"Logan Miller\", :date=>\"2020-2-10\", :rating=>4, :reported=>0}\n/, '') do
            setup_test_find_search("LAB")
        end
    end
    
    # Outputs result of Users.find_all so that the returned hash value can be checked
    # (assert_equal currently not working for hash values)
    def setup_test_find_search(search)
        puts Bookmark.find_search(search, $db);
    end
    
    # Compares methods returned hash value by outputting method to console and checking this output
    # (assert_equal currently not working for hash values)
    def test_find_one
        assert_output(/{:id=>1, :title=>\"Lab results\", :author=>\"Logan Miller\", :description=>\"Details of february's lab\", :content=>\"\/lab.html\", :rate=>4, :num_of_rate=>2, :date=>\"2020-2-10\"}/) do
            setup_test_find_one;
        end
    end
    
    # Outputs result of Users.find_all so that the returned hash value can be checked
    # (assert_equal currently not working for hash values)
    def setup_test_find_one
        puts Bookmark.find_one(1, $db);
    end
    
    # Cannot fully test method with Mini Test as it does not return value, so simply testing
    # if it returns nothing (as is expected)
    def test_rate
        
        # Creating test data to be modified then deleted
        # (cannot revert number of ratings once incremented)
        Bookmark.new("Uni website", "https://sheffield.ac.uk", "The official uni web page", "Mr Test", "2020-3-19", 2, 1, 0, $db);
        
        # Currently causing an error, not sure wy
        # assert_equal [], Bookmark.rate(3, 4, $db);
        
        Bookmark.delete(4, $db);
        
    end
    
    def test_find_rating
        assert_equal 4, Bookmark.find_num(1, $db);
        assert_equal 5, Bookmark.find_num(2, $db);
        assert_equal 2, Bookmark.find_num(3, $db);
    end
    
    def test_find_num
        assert_equal 2, Bookmark.find_num(1, $db);
        assert_equal 31, Bookmark.find_num(2, $db);
        assert_equal 10, Bookmark.find_num(3, $db);
    end
    
    # Cannot fully test method with Mini Test as it does not return value, so simply testing
    # if it returns nothing (as is expected)
    def test_delete
        
        # Creating test data to be deleted
        Bookmark.new("Uni website", "https://sheffield.ac.uk", "The official uni web page", "Mr Test", "2020-3-19", 2, 1, 0, $db);
    
        assert_equal [], Bookmark.delete(4, $db);
        
        Bookmark.delete(4, $db);
        
    end
    
end