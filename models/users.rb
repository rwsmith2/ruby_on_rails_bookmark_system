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
    
    def Users.new(user_id,firstname,surname,email, mobile_number,password)
         db= @db=SQLite3::Database.new 'database/bookmark_system.sqlite'
         query= "INSERT INTO user(user_id,firstname,surname,email, mobile_number,password) 
                                                                      VALUES(?,?,?,?,?,?)"
         result=db.execute query, user_id,firstname,surname,email, mobile_number,password
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
            
end