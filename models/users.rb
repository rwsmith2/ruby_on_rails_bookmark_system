require 'sqlite3'
require 'sinatra/reloader'


module Users
    
    # Returns the name, access level and suspension status of all users with the search parameter within their first name
    def Users.find_search(search,db)
        
        result=[]
        if search && search!=''
            query= "SELECT user.user_id,firstname,surname,access_level,suspended FROM user WHERE firstname LIKE ? ;"
            rows=db.execute query, '%'+search+'%' 
            rows.each do |row|
                result.push({id: row[0], firstname: row[1], surname: row[2], access_level: row[3], suspended:row[4]})
            end
        end
        return result 
    end
    
    # Returns all users ID, name, access level and suspension status
    def Users.find_all(db)
        
        result=[]
            query= "SELECT user.user_id,firstname,surname,access_level,suspended FROM user ;"
            rows=db.execute query 
            rows.each do |row|
                result.push({id: row[0], firstname: row[1], surname: row[2], access_level: row[3], suspended:row[4]})
            end
        
        return result 
    end
    
    # Returns ID, name, email, phone number, password and access level of user with given ID
    def Users.find_one(id,db)
      
        result=[]
        query= "SELECT user.user_id,firstname,surname,email,mobile_number,password,access_level FROM user WHERE user_id= ?;"
        rows=db.execute query,id 
        row=rows[0]
        result={id: row[0], firstname: row[1], surname: row[2],email: row[3], phone: row[4],password: row[5], access_level:row[6]}   
        return result 
    end
    
    # Creates a new user with given values
    def Users.new(firstname, surname, email, mobile_number, password, db)
   
         query= "INSERT INTO user(firstname,surname,email, mobile_number,password,access_level,suspended) 
                                                                      VALUES(?,?,?,?,?,?,?)"
         result=db.execute query, firstname,surname,email, mobile_number,password,"registered" , 0
    end
    
    # Checks users password matches confirmed password during registering stage
    def Users.confirm_password(password, confirm_password,db)

        if (password==confirm_password)
            return true
        else
            return false
        end
    end
    
    # Checks if email given already being used by a user
    def Users.check_same_email(email,db)
    
        if email && email!='' 
            query= "SELECT email FROM user;"
            rows=db.execute query  
            rows.each do |row|
                if row[0]==email 
                    return true  
                end          
            end
        end
        return false
    end
    
    # Checks if email & password given by user are correct, if so user can log in
    def Users.validation(email, password,db)
   
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
    
    # Checks if user is currently logged in
    def Users.check_for_login(session,db)

        if session && session!=""
            return true
        else
            return false
        end
    end
    
    # Returns name of user with given ID
    def Users.find_name(id,db)
         query= "SELECT firstname FROM user WHERE user_id=?;"
         rows=db.execute query, id
         row=rows[0]
         return row[0]
    end
        
    # Returns ID of user with given email & password combination 
    def Users.find_id(email, password,db)
          query= "SELECT user_id FROM user WHERE email=? AND password=?;"
          rows=db.execute query, email,password
          row=rows[0]
          return row[0]
    end
    
    # Returns access level of user with given ID
    def Users.check_role(id,db)
            query= "SELECT access_level FROM user WHERE user_id=?;"
            rows=db.execute query,id
            row=rows[0]
            return row[0]
    end
    
    # Suspends user with given ID
    def Users.suspend(id,db)
       query= "UPDATE user SET suspended=? WHERE user_id=?;"
       result=db.execute query,1,id   
    end
    
    # Unsuspends user with given ID
    def Users.unsuspend(id,db)
       query= "UPDATE user SET suspended=? WHERE user_id=?;"
       result=db.execute query,0,id   
    end
    
    # Returns true if user with given ID is suspended
    def Users.under_suspend(id,db)
       query= "SELECT suspended FROM user WHERE user_id=?;"
       rows=db.execute query,id 
       row=rows[0]
       if row[0]==1
            return true
       else
            return false
       end
   end
       
   # Changes access level of user with given ID to given access level
   def Users.set_role(access_level, id,db)   
    
       query= "UPDATE user SET access_level=? WHERE user_id=?;"
       rows=db.execute query, access_level,id
   end
   
   # Changes password of user with given ID to given password
   def Users.change_password(password, id,db)  
   
       query= "UPDATE user SET password=? WHERE user_id=?;"
       rows=db.execute query, password,id
   end
       
 
        
end
