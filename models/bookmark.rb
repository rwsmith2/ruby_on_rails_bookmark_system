require 'sqlite3'
require 'sinatra/reloader'

module Bookmark
    def Bookmark.add(id,title,content,descriptiont,author,date,rating,num_rating,reported)
        db=SQLite3::Database.new 'database/bookmark_system.sqlite'
        query= "INSERT INTO bookmark(id,title,content,descriptiont,author,date,rating,num_rating,reported) 
                                                                      VALUES(?,?,?,?,?,?,?,?,?)"
        
        result=db.execute query, id,title,content,descriptiont,author,date,rating,num_rating,reported
        
    end
    
end