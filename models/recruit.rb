require 'sqlite3'
require 'sinatra/reloader'


module Recruit
    def Recruit.find_name(search)
        result=[]
        if search && search!=''
            db=SQLite3::Database.new 'database/recruit.sqlite'
            query= "SELECT name,gender FROM employee WHERE name LIKE ?;"
            rows=db.execute query, '%'+search+'%' 
            rows.each do |row|
                result.push({id: row[0], name: row[1]})
            end
        end
        return result 
    end
    
    def Recruit.new(id, name,gender, age)
         db= @db=SQLite3::Database.new 'database/recruit.sqlite'
         query= "INSERT INTO employee(id,name, gender,age) VALUES(?,?,?,?)"
         result=db.execute query, id, name,gender, age
    end
    
    def Recruit.validation(id,name)
        if id && id!='' && name && name!=''
            db=SQLite3::Database.new 'database/recruit.sqlite'
            query= "SELECT id,name FROM employee;"
            rows=db.execute query  
            rows.each do |row|
                if row[0]==(id.to_i) && row[1]==name
                    return true  
                end          
            end
        end
        return false
    end
            
end