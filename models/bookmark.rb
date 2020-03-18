require 'sqlite3'
require 'sinatra/reloader'

module Bookmark
    def Bookmark.new(title,content,description,author,date,rating,num_rating,reported,db)
        
        query= "INSERT INTO bookmark(title,content,description,author,date_created,rating,num_of_ratings,reported) 
                                                                      VALUES(?,?,?,?,?,?,?,?)"
        
        result=db.execute query, title,content,description,author,date,rating,num_rating,reported
        
    end
    
      def Bookmark.find_all(db)
        result=[]
            query= "SELECT title,author,date_created,rating,reported,bookmark_id FROM bookmark;"
            rows=db.execute query 
            rows.each do |row|
                result.push({title: row[0], author: row[1], date: row[2], rating: row[3],reported: row[4], id:row[5]})
            end
        
        return result 
    end
    
    def Bookmark.reported(id,db)
     
       query= "UPDATE bookmark SET reported=? WHERE bookmark_id=?;"
       result=db.execute query,1,id   
    end
    
    def Bookmark.unreported(id,db)
     
      query= "UPDATE bookmark SET reported=? WHERE bookmark_id=?;"       
      result=db.execute query,0,id   
    end
    
    def Bookmark.find_search(search,db)     
        result=[]
        if search && search!=''
            query= "SELECT title,author,date_created,rating,reported FROM bookmark WHERE title LIKE ? ;"
            rows=db.execute query, '%'+search+'%' 
            rows.each do |row|
                result.push({title: row[0], author: row[1], date: row[2], rating: row[3],reported: row[4]})
            end
        end
        return result 
    end
    
    def Bookmark.find_one(id,db)
        result=[]
        query= "SELECT bookmark_id,title,author,description,content,rating,num_of_ratings,date_created 
                                          FROM bookmark WHERE bookmark_id= ?;"

        rows=db.execute query,id 
        row=rows[0]
        result={id: row[0],title: row[1], author: row[2], description: row[3],content: row[4], rate: row[5],num_of_rate: row[6], date:row[7]}   
        return result 
    end
    
    def Bookmark.rate(rating_points, id,db)   
       last_rate=Bookmark.find_rating(id,db)
       last_num=Bookmark.find_num(id,db)
       current_num=last_num+1
       current_rate= (last_rate*last_num+rating_points).to_f/current_num
       result='%.2f' % current_rate
       query= "UPDATE bookmark SET rating=? WHERE bookmark_id=?;"
       rows=db.execute query, result,id
       query= "UPDATE bookmark SET num_of_ratings=? WHERE bookmark_id=?;"
       rows=db.execute query, current_num,id
   end
    
    def Bookmark.find_rating(id,db)
         query= "SELECT rating FROM bookmark WHERE bookmark_id=?;"
         rows=db.execute query, id
         row=rows[0]
         return row[0]
    end
    
    def Bookmark.find_num(id,db)
         query= "SELECT num_of_ratings FROM bookmark WHERE bookmark_id=?;"
         rows=db.execute query, id
         row=rows[0]
         return row[0]
    end
    
    def Bookmark.delete(id,db)
         query= "DELETE FROM bookmark WHERE bookmark_id=?"
         result=db.execute query, id
    end
    
    
end