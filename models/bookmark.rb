require 'sqlite3'
require 'sinatra/reloader'

module Bookmark
    def Bookmark.add(title,content,description,author,date,rating,num_rating,reported,db)
        db=SQLite3::Database.new 'database/bookmark_system.sqlite'
        query= "INSERT INTO bookmark(id,title,content,description,author,date,rating,num_rating,reported) 
                                                                      VALUES(?,?,?,?,?,?,?,?,?)"
        
        result=db.execute query, title,content,description,author,date,rating,num_rating,reported
        
    end
    
      def Bookmark.find_all(db)
        db = SQLite3::Database.new 'database/bookmark_system.sqlite'
        result=[]
            query= "SELECT title,author,date_created,rating reported FROM bookmark;"
            rows=db.execute query 
            rows.each do |row|
                result.push({title: row[0], author: row[1], date: row[2], rating: row[3],reported: row[4]})
            end
        
        return result 
    end
    
end