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
        assert_equal [], Bookmark.new("Uni website", "https://sheffield.ac.uk", "The official uni web page", "Mr Test", 4, "2020-3-19", 2, 1, 0, "tag1", "tag2", "tag3", $db);    
        
        # Change test data back to original form
        Bookmark.delete(4, $db)
    end
    
    # Compares methods returned hash value by outputting method to console and checking this output
    # (assert_equal currently not working for hash values).
    # Test occassionally fails due to new bookmark being created in another unit test
    # failing to be deleted
    def test_find_all
        
        # Returns test data to original form (incase a previous test did not delete it)
          query= "DELETE FROM bookmark WHERE bookmark_id>=?"
          result=$db.execute query, 4
        
        # Test for filtering by rate
        assert_output(/{:title=>\"My website\", :author=>\"James Acaster\", :date=>\"2020-3-19\", :rating=>5, :num_of_rate=>31, :reported=>0, :id=>2}\n{:title=>\"Lab results\", :author=>\"Logan Miller\", :date=>\"2020-2-10\", :rating=>4, :num_of_rate=>2, :reported=>0, :id=>1}\n{:title=>\"Funny jokes\", :author=>\"Jimmy Carr\", :date=>\"2019-12-9\", :rating=>0, :num_of_rate=>0, :reported=>1, :id=>3}\n/, '') do
            puts Bookmark.find_all(true, false, false, $db)
        end
        # Test for filtering by date
        assert_output(/{:title=>\"My website\", :author=>\"James Acaster\", :date=>\"2020-3-19\", :rating=>5, :num_of_rate=>31, :reported=>0, :id=>2}\n{:title=>\"Lab results\", :author=>\"Logan Miller\", :date=>\"2020-2-10\", :rating=>4, :num_of_rate=>2, :reported=>0, :id=>1}\n{:title=>\"Funny jokes\", :author=>\"Jimmy Carr\", :date=>\"2019-12-9\", :rating=>0, :num_of_rate=>0, :reported=>1, :id=>3}\n/, '') do
            puts Bookmark.find_all(false, true, false, $db)
        end
        # Test for filtering by reported
        assert_output(/{:title=>\"Funny jokes\", :author=>\"Jimmy Carr\", :date=>\"2019-12-9\", :rating=>0, :num_of_rate=>0, :reported=>1, :id=>3}\n{:title=>\"Lab results\", :author=>\"Logan Miller\", :date=>\"2020-2-10\", :rating=>4, :num_of_rate=>2, :reported=>0, :id=>1}\n{:title=>\"My website\", :author=>\"James Acaster\", :date=>\"2020-3-19\", :rating=>5, :num_of_rate=>31, :reported=>0, :id=>2}\n/, '') do
            puts Bookmark.find_all(false, false, true, $db)
        end
        # Test for all filters selected
        assert_output(/{:title=>\"My website\", :author=>\"James Acaster\", :date=>\"2020-3-19\", :rating=>5, :num_of_rate=>31, :reported=>0, :id=>2}\n{:title=>\"Lab results\", :author=>\"Logan Miller\", :date=>\"2020-2-10\", :rating=>4, :num_of_rate=>2, :reported=>0, :id=>1}\n{:title=>\"Funny jokes\", :author=>\"Jimmy Carr\", :date=>\"2019-12-9\", :rating=>0, :num_of_rate=>0, :reported=>1, :id=>3}\n/, '') do
            puts Bookmark.find_all(true, true, true, $db)
        end
    end

    # Cannot fully test method with Mini Test as it does not return value, so simply testing
    # if it returns nothing (as is expected)
    def test_reported
        assert_equal [], Bookmark.reported(1, $db);
        
        # Change test data back to original form
        Bookmark.unreported(1, $db);
    end
    
    # Compares methods returned hash value by outputting methods to console and checking this output
    # (assert_equal currently not working for hash values)
    def test_find_search
        # Test search for 'jokes', filtered by rate
        assert_output(/{:title=>\"Funny jokes\", :author=>\"Jimmy Carr\", :date=>\"2019-12-9\", :rating=>0, :num_of_rate=>0, :reported=>1, :id=>3}\n/, '') do
            puts Bookmark.find_search(true, false, false, "jokes", "title", $db);
        end
        # Test search for 'LAB', filtered by date
        assert_output(/{:title=>\"Lab results\", :author=>\"Logan Miller\", :date=>\"2020-2-10\", :rating=>4, :num_of_rate=>2, :reported=>0, :id=>1}\n/, '') do
            puts Bookmark.find_search(false, true, false, "lab", "title", $db);
        end
        # Test search for 'no result', filtered by reported
        assert_output(//, '') do
            puts Bookmark.find_search(false, false, true, "lab", "title", $db);
        end
    end
    
    # Compares methods returned hash valuea by outputting methods to console and checking this output
    # (assert_equal currently not working for hash values)
    def test_find_one
        assert_output(/{:id=>1, :title=>\"Lab results\", :author=>\"Logan Miller\", :description=>\"Details of february's lab\", :content=>\"\/lab.html\", :rate=>4, :num_of_rate=>2, :date=>\"2020-2-10\", :tag1=>\"Lab\", :tag2=>nil, :tag3=>nil}\n/, '') do
           puts Bookmark.find_one(1, $db);
        end
    end
    
    def test_find_rating
        assert_equal 4, Bookmark.find_rating(1, $db);
        assert_equal 5, Bookmark.find_rating(2, $db);
        assert_equal 0, Bookmark.find_rating(3, $db);
    end
    
    def test_find_num
        assert_equal 2, Bookmark.find_num(1, $db);
        assert_equal 31, Bookmark.find_num(2, $db);
        assert_equal 0, Bookmark.find_num(3, $db);
    end
    
    def test_delete
        
        # Creates test data to be deleted
        Bookmark.new("Uni website", "https://sheffield.ac.uk", "The official uni web page", "Mr Test", 4, "2020-3-19", 2, 1, 0, "tag1", "tag2", "tag3", $db);
        
        assert_equal [], Bookmark.delete(4, $db);
        
        # Returns test data to original form (incase delete method failed)
        Bookmark.delete(4, $db)
    end
    
    def test_duplicate
        assert_equal true, Bookmark.duplicate("Lab results", $db);
        assert_equal false, Bookmark.duplicate("Non duplicate title", $db);
    end

    # Compares methods returned hash valuea by outputting methods to console and checking this output
    # (assert_equal currently not working for hash values)
    def test_find_my_bookmark
        assert_output(/{:id=>2, :title=>"My website", :date=>"2020-3-19"}/, '') do
            puts Bookmark.find_my_bookmark(2, $db);
        end
    end
    
    def test_update
        
        # Creates test data to be modified and then deleted
        Bookmark.new("Uni website", "https://sheffield.ac.uk", "The official uni web page", "Mr Test", 4, "2020-3-19", 2, 1, 0, "tag1", "tag2", "tag3", $db);
        
        assert_equal [], Bookmark.update(4, "New website", "Mr Test", "https://shef.ac.uk", "New website", "2020-4-19", "new tag 1", "new tag 2", "new tag 3", $db);
        
        # Returns test data to original form
        Bookmark.delete(4, $db)
        
    end

    def test_own_bookmark
        assert_equal true, Bookmark.own_bookmark(1, 1, $db);
        assert_equal false, Bookmark.own_bookmark(2, 1, $db);
    end

    # Compares methods returned hash valuea by outputting methods to console and checking this output
    # (assert_equal currently not working for hash values)
    def test_add_comment
        assert_equal [], Bookmark.add_comment(2, "My Comment 2", "Jimmy Carr", "Blah blah blah", "2020-4-19", $db);
    
        # Returns test data to original form
        query = "DELETE FROM comment WHERE title='My Comment 2'";
        result = $db.execute query;
        
    end
    
    def test_number_of_comments
        assert_equal 0, Bookmark.number_of_comments(1, $db);
        assert_equal 1, Bookmark.number_of_comments(2, $db);
    end
    
    # Compares methods returned hash valuea by outputting methods to console and checking this output
    # (assert_equal currently not working for hash values)
    def test_find_comments
        assert_output(/{:title=>"Test comment", :content=>"Test!!!", :author=>"Logan Miller", :date=>"2020-3-28"}/, '') do
            puts Bookmark.find_comments(2, $db);
        end
    end
    
    # Compares methods returned hash valuea by outputting methods to console and checking this output
    # (assert_equal currently not working for hash values)
    def test_find_tags
        assert_output(/{:name=>"Lab"}\n{:name=>"Website"}\n{:name=>"Fun"}\n/, '') do
            puts Bookmark.find_tags($db);
        end
    end
    
    def test_same_tag
        assert_equal true, Bookmark.same_tag("tag1", "tag2", "tag2", $db);
        assert_equal false, Bookmark.same_tag("tag1", "tag2", "tag3", $db);
    end
    
    # Compares methods returned hash valuea by outputting methods to console and checking this output
    # (assert_equal currently not working for hash values)
    def test_create_tag
        assert_equal [], Bookmark.create_tag("new tag", $db);
        
        # Returns test data to original form
        query= "DELETE FROM tag WHERE tag = 'new tag';";
        rows = $db.execute query;
        
    end
    
    def test_duplicate_tag
        assert_equal true, Bookmark.duplicate_tag("Fun", $db);
        assert_equal false, Bookmark.duplicate_tag("Not fun", $db);
    end
end    
   