require 'sqlite3'
require 'sinatra/reloader'

module Bookmark
    
    # Create new bookmark
    def Bookmark.new(title, content, description, author,author_id, date, rating, num_rating, reported,tag1,tag2,tag3,db)
        
        query= "INSERT INTO bookmark(title,content,description,author,author_id,date_created,rating,num_of_ratings,reported,
                                                               bookmark_tag_one,bookmark_tag_two,bookmark_tag_three) 
                                                                      VALUES(?,?,?,?,?,?,?,?,?,?,?,?)"
        
        result = db.execute query, title, content, description, author,author_id, date, rating, 
                                                                num_rating, reported,tag1,tag2,tag3
        
    end
    
    # Return all bookmarks
     def Bookmark.find_all(filter_by_rate,filter_by_date,db)
        result = []
       if filter_by_rate==true
         query = "SELECT title,author,date_created,rating,num_of_ratings,reported,bookmark_id FROM bookmark  
                                                                            ORDER BY rating DESC;"
       elsif filter_by_date==true
         query = "SELECT title,author,date_created,rating,num_of_ratings,reported,bookmark_id FROM bookmark  
                                                                            ORDER BY date_created DESC;"
       else 
         query = "SELECT title,author,date_created,rating,num_of_ratings,reported,bookmark_id FROM bookmark;"
       end
        rows = db.execute query 
        rows.each do |row|
            result.push({title: row[0], author: row[1], date: row[2], rating: row[3],num_of_rate: row[4],reported: row[5],id: row[6]})
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
    def Bookmark.find_search(filter_by_rate,filter_by_date,search, db)     
        result = []
        
        #If user has entered something in the search field
        if search && search!=''
          if filter_by_rate==true
              query = "SELECT title,author,date_created,rating,num_of_ratings,reported,bookmark_id FROM bookmark WHERE title LIKE ? 
                    ORDER BY rating DESC;"  
          elsif filter_by_date==true
             query = "SELECT title,author,date_created,rating,num_of_ratings,reported,bookmark_id FROM bookmark  WHERE title LIKE ? 
                                                                            ORDER BY date_created DESC;"   
          else
            query = "SELECT title, author, date_created, rating, num_of_ratings, reported,bookmark_id FROM bookmark WHERE title LIKE ? ;"
          end
            rows = db.execute query, '%'+search+'%' 
            rows.each do |row|
                result.push({title: row[0], author: row[1], date: row[2], rating: row[3],num_of_rate: row[4],reported: row[5],id: row[6]})
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
    
    def Bookmark.change_to_duplicate(title,id,db)
       found=Bookmark.find_one(id, db)
       query= "SELECT title FROM bookmark;"
       rows=db.execute query  
       rows.each do |row|
          if row[0]!=found[:title]&&row[0]==title 
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
    
    def Bookmark.update(id,title ,author,description,content,db)

       query= "UPDATE bookmark SET title=?, author=?, description=?,content=? WHERE bookmark_id=?;"
       result=db.execute query, title,author,description,content,id   
    end
    
    def Bookmark.not_change(id,title ,author,description,content,db)
        
        found=Bookmark.find_one(id, db)
        if(title==found[:title]&&author==found[:author]&&
               description==found[:description]&&content==found[:content])
          return true
        end
        return false
    end
    
    def Bookmark.own_bookmark(id_bm,id_login, db)
       query= "SELECT author_id FROM bookmark WHERE bookmark_id=?;"
       rows = db.execute query, id_bm
       row = rows[0]
        if row[0]==id_login
            return true
        end
        return false
    end
    
    def Bookmark.add_comment(id_bm,title,author,content,date,db)
       query= "INSERT INTO comment(title,content,author,date_created,bookmark_id) 
                                                                      VALUES(?,?,?,?,?)"
       result = db.execute query, title, content, author,date, id_bm
    end
    
    def Bookmark.number_of_comments(id_bm,db)
        query= "SELECT COUNT(*) FROM comment WHERE bookmark_id=?;"
        rows = db.execute query, id_bm
        row=rows[0]
        return row[0]
    end
    
    def Bookmark.find_comments(id_bm,db)
        result=[]
        query= "SELECT title, content,author,date_created FROM comment WHERE bookmark_id=?;"
        rows = db.execute query,id_bm    
        rows.each do |row|
            result.push({title: row[0], content: row[1], author: row[2], date: row[3]})
        end
        
        return result
    end
    
    def Bookmark.find_tags(db)
        result=[]
        query= "SELECT tag FROM tag;"
        rows = db.execute query 
        rows.each do |row|
            result.push({name: row[0]})
        end
        return result
    end
end