require 'sqlite3'
require 'sinatra/reloader'


module Users
    def Users.findSearch(search, db)
        result=[]
        if search && search!=''
            query= "SELECT user.user_id,firstname,surname,access_level,suspended FROM user JOIN user_condition 
                                                           WHERE user.firstname LIKE ? AND user.user_id==user_condition.user_id;"
            rows=db.execute query, '%'+search+'%' 
            rows.each do |row|
                result.push({id: row[0], firstname: row[1], surname: row[2], access_level: row[3], suspended:row[4]})
            end
        end
        return result 
    end
    
    def Users.findAll(db)
        result=[]
            query= "SELECT user.user_id,firstname,surname,access_level,suspended FROM user JOIN user_condition WHERE user.user_id==user_condition.user_id;"
            rows=db.execute query 
            rows.each do |row|
                result.push({id: row[0], firstname: row[1], surname: row[2], access_level: row[3], suspended:row[4]})
            end
        
        return result 
    end
    
    def Users.findOne(id, db)
        result=[]
        query= "SELECT user.user_id,firstname,surname,email,mobile_number,password,access_level FROM user JOIN user_condition WHERE user.user_id=? AND user_condition.user_id=?;"
        rows=db.execute query,id, id 
        row=rows[0]
        result={id: row[0], firstname: row[1], surname: row[2],email: row[3], phone: row[4],password: row[5], access_level:row[6]}   
        return result 
    end
    
    def Users.new(firstname, surname, email, mobile_number, password, db)
         query= "INSERT INTO user(firstname,surname,email, mobile_number,password) 
                                                                      VALUES(?,?,?,?,?)"
         result=db.execute query, firstname,surname,email, mobile_number,password
         query2= "INSERT INTO  user_condition(access_level,suspended) VALUES(?,?)"
         result2=db.execute query2,"registered" , 0
        
    end
    
    def Users.confirmPassword(password, confirm_password, db)
        if (password==confirm_password)
            return true
        else
            return false
        end
    end
    def Users.validation(email, password, db)
        if email && email!='' && password && password!=''
            query= "SELECT email,password FROM user;"
            rows=db.execute query  
            rows.each do |row|
                if row[0]==email && row[1]==password
                    return true  
                end          
            end
        end
        return false
    end 
    def Users.checkForLogin(session, db)
        if session && session!=""
            return true
        else
            return false
        end
    end
    
    def Users.findName(id, db)
         query= "SELECT firstname FROM user WHERE user_id=?;"
         rows=db.execute query, id
         row=rows[0]
         return row[0]
    end
        
        
    def Users.findId(email, password, db)
          query= "SELECT user_id FROM user WHERE email=? AND password=?;"
          rows=db.execute query, email,password
          row=rows[0]
          return row[0]
    end
    
    def Users.checkRole(id, db)
            query= "SELECT access_level FROM user_condition WHERE user_id=?;"
            rows=db.execute query,id
            row=rows[0]
            return row[0]
    end
    
    def Users.suspend(id, db)
       query= "UPDATE user_condition SET suspended=? WHERE user_id=?;"
       result=db.execute query,1,id   
    end
    
    def Users.unsuspend(id, db)
       query= "UPDATE user_condition SET suspended=? WHERE user_id=?;"
       result=db.execute query,0,id   
    end
    
   def Users.underSuspend(id, db)
       query= "SELECT suspended FROM user_condition WHERE user_id=?;"
       rows=db.execute query,id 
       row=rows[0]
       if row[0]==1
            return true
       else
            return false
       end
   end
       
   def Users.setRole(access_level, id, db)   
       query= "UPDATE user_condition SET access_level=? WHERE user_id=?;"
       rows=db.execute query, access_level,id
   end
    
   def Users.changePassword(password, id, db)  
       query= "UPDATE user SET password=? WHERE user_id=?;"
       rows=db.execute query, password,id
   end
       
 
        
end
