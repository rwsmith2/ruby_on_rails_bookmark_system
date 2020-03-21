require 'sqlite3'
require 'sinatra/reloader'

module Bookmark
    
    # Create new bookmark
    def Bookmark.new(title, content, description, author,author_id, date, rating, num_rating, reported, db)
        
        query= "INSERT INTO bookmark(title,content,description,author,author_id,date_created,rating,num_of_ratings,reported) 
                                                                      VALUES(?,?,?,?,?,?,?,?,?)"
        
        result = db.execute query, title, content, description, author,author_id, date, rating, num_rating, reported
        
    end
    
    # Return all bookmarks
    def Bookmark.find_all(db)
        result = []
        query = "SELECT title,author,date_created,rating,reported,bookmark_id FROM bookmark;"
        rows = db.execute query 
        rows.each do |row|
            result.push({title: row[0], author: row[1], date: row[2], rating: row[3],reported: row[4], id:row[5]})
        end
        
        return result 
    end
    
    # Report bookmark with given ID
    def Bookmark.reported(id, db)
     
       query = "UPDATE bookmark SET reported=? WHERE bookmark_id=?;"
       result = db.execute query, 1, id   
    end
    
    # Unreport bookmark with given ID
    def Bookmark.unreported(id, db)
      query = "UPDATE bookmark SET reported=? WHERE bookmark_id=?;"       
      result = db.execute query, 0, id   
    end
    
    # Return bookmark title, author, date, rating & reported status if bookmark contains search term
    def Bookmark.find_search(search, db)     
        result = []
        
        #If user has entered something in the search field
        if search && search!=''
            query = "SELECT title, author, date_created, rating, reported FROM bookmark WHERE title LIKE ? ;"
            rows = db.execute query, '%'+search+'%' 
            rows.each do |row|
                result.push({title: row[0], author: row[1], date: row[2], rating: row[3],reported: row[4]})
            end
        end        
        return result 
    end
    
    # Return ID, title, author, description, content, rating & date of bookmark with given ID
    def Bookmark.find_one(id, db)
        result = []
        query = "SELECT bookmark_id,title,author,description,content,rating,num_of_ratings,date_created 
                                          FROM bookmark WHERE bookmark_id= ?;"

        rows = db.execute query,id 
        row = rows[0]
        result = {id: row[0],title: row[1], author: row[2], description: row[3],content: row[4], rate: row[5],num_of_rate: row[6], date:row[7]}   
        return result 
    end
    
    # Calculate new average rating of bookmark based of given rating
    def Bookmark.rate(rating_points, id, db)   
       last_rate = Bookmark.find_rating(id,db)
       last_num = Bookmark.find_num(id,db)
        
       current_num = last_num + 1
       current_rate = (last_rate * last_num + rating_points).to_f / current_num
       
       result = '%.2f' % current_rate
       
       query = "UPDATE bookmark SET rating=? WHERE bookmark_id=?;"
       rows = db.execute query, result,id
       
       query = "UPDATE bookmark SET num_of_ratings=? WHERE bookmark_id=?;"
       rows = db.execute query, current_num,id
   end
    
   # Return the rating of the bookmark with given ID
   def Bookmark.find_rating(id, db)
       query= "SELECT rating FROM bookmark WHERE bookmark_id=?;"
       rows = db.execute query, id
       row = rows[0]
       return row[0]
    end
    
    # Return number of ratings of bookmark with given ID
    def Bookmark.find_num(id, db)
        query= "SELECT num_of_ratings FROM bookmark WHERE bookmark_id=?;"
        rows=db.execute query, id
        row=rows[0]
        return row[0]
    end
    
    # Delete bookmark with given ID
    def Bookmark.delete(id,db)
        query= "DELETE FROM bookmark WHERE bookmark_id=?"
        result=db.execute query, id
    end
    
    def Bookmark.duplicate(title,db)   
       query= "SELECT title FROM bookmark;"
       rows=db.execute query  
       rows.each do |row|
          if row[0]==title 
              return true  
          end          
       end
       
      return false
    end
    
    
    def Bookmark.find_my_bookmark(id, db)
        result = []
        query = "SELECT bookmark_id,title,date_created  FROM bookmark  WHERE author_id=?;"
        rows = db.execute query,id 
        rows.each do |row|
         result.push({id: row[0],title: row[1], date:row[2]})  
        end
        return result 
    end
    
end