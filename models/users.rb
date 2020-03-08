require 'sqlite3'
require 'sinatra/reloader'


module Users
    def Users.find_name(search)
        result=[]
        if search && search!=''
            db=SQLite3::Database.new 'database/bookmark_system.sqlite'
            query= "SELECT firstname,surname FROM user WHERE user_id LIKE ?;"
            rows=db.execute query, '%'+search+'%' 
            rows.each do |row|
                result.push({firstname: row[0], surname: row[1]})
            end
        end
        return result 
    end
    
    def Users.findAll()
        result=[]
            db=SQLite3::Database.new 'database/bookmark_system.sqlite'
            query= "SELECT user.user_id,firstname,surname,access_level,suspended FROM user JOIN user_condition WHERE user.user_id==user_condition.user_id;"
            rows=db.execute query 
            rows.each do |row|
                result.push({id: row[0], firstname: row[1], surname: row[2], access_level: row[3], suspended:row[4]})
            end
        
        return result 
    end
    
    def Users.findOne(id)
        result=[]
        db=SQLite3::Database.new 'database/bookmark_system.sqlite'
        query= "SELECT user.user_id,firstname,surname,email,mobile_number,password,access_level FROM user JOIN user_condition WHERE user.user_id=? AND user_condition.user_id=?;"
        rows=db.execute query,id, id 
        row=rows[0]
        result={id: row[0], firstname: row[1], surname: row[2],email: row[3], phone: row[4],password: row[5], access_level:row[6]}   
        return result 
    end
    
    def Users.new(firstname,surname,email, mobile_number,password)
         db=SQLite3::Database.new 'database/bookmark_system.sqlite'
         query= "INSERT INTO user(firstname,surname,email, mobile_number,password) 
                                                                      VALUES(?,?,?,?,?)"
         result=db.execute query, firstname,surname,email, mobile_number,password
         query2= "INSERT INTO  user_condition(access_level,suspended) VALUES(?,?)"
         result2=db.execute query2,"registered" , 0
        
    end
    
    def Users.validation(name,password)
        if name && name!='' && password && password!=''
            db=SQLite3::Database.new 'database/bookmark_system.sqlite'
            query= "SELECT firstname,password FROM user;"
            rows=db.execute query  
            rows.each do |row|
                if row[0]==name && row[1]==password
                    return true  
                end          
            end
        end
        return false
    end 
    def Users.checkForLogin(session)
        if session && session!=""
            return true
        else
            return false
        end
    end
    
    def Users.findId(name,password)
          db=SQLite3::Database.new 'database/bookmark_system.sqlite'
            query= "SELECT user_id FROM user WHERE firstname=? AND password=?;"
            rows=db.execute query, name,password
            row=rows[0]
            return row[0]
    end
    
    def Users.checkRole(id)
            db=SQLite3::Database.new 'database/bookmark_system.sqlite'
            query= "SELECT access_level FROM user_condition WHERE user_id=?;"
            rows=db.execute query,id
            row=rows[0]
            return row[0]
    end
    
    def Users.suspend(id)
       db=SQLite3::Database.new 'database/bookmark_system.sqlite'
       query= "UPDATE user_condition SET suspended=? WHERE user_id=?;"
       result=db.execute query,1,id   
    end
    
    def Users.unsuspend(id)
       db=SQLite3::Database.new 'database/bookmark_system.sqlite'
       query= "UPDATE user_condition SET suspended=? WHERE user_id=?;"
       result=db.execute query,0,id   
    end
    
   def Users.underSuspend(id)
       db=SQLite3::Database.new 'database/bookmark_system.sqlite'
       query= "SELECT suspended FROM user_condition WHERE user_id=?;"
       rows=db.execute query,id 
       row=rows[0]
       if row[0]==1
            return true
       else
            return false
       end
   end
       
   def Users.setRole(access_level,id)   
       db=SQLite3::Database.new 'database/bookmark_system.sqlite'
       query= "UPDATE user_condition SET access_level=? WHERE user_id=?;"
       rows=db.execute query, access_level,id
   end
    
   def Users.changePassword(password,id)   
       db=SQLite3::Database.new 'database/bookmark_system.sqlite'
       query= "UPDATE user SET password=? WHERE user_id=?;"
       rows=db.execute query, password,id
   end
       
 
        
end