require 'sinatra'
require 'sinatra/reloader'
also_reload 'models/*'
require_relative 'models/users.rb'
require_relative 'models/bookmark.rb'


set :bind, '0.0.0.0'
enable :sessions

$db = SQLite3::Database.new 'database/bookmark_system.sqlite'

#User Part--------------------------   

get '/' do
   
   # If the user is logged in
   if Users.check_for_login(session[:login],$db)
    @name=session[:name]
   else
    @name=''
   end
    erb :home
end



get '/login' do
     erb :login
end

post '/login' do
   
   @validation = true
   @suspend = false
    
   @username = params[:email]
   @password = params[:password]  
   
   # If username & password matches
   if Users.validation(@username, @password, $db)
       
       @id = Users.find_id(@username, @password, $db)
       
       if Users.under_suspend(@id, $db)
           @suspend = true
           erb :login
       else
           @id = Users.find_id(@username, @password, $db)
           
           session[:login] = true 
           session[:role] = Users.check_role(@id, $db)
           session[:name] = Users.find_name(@id, $db)
           session[:id] = @id
           
           redirect '/'
     end
   else      
      @validation = false
      erb :login
   end
  
end

get '/register' do

      erb :register

end

post '/register' do
    @validation = true
    @confirmation = true
    @unique_email = true
    
    @firstname = params[:firstname]
    @surname = params[:surname]
    @email = params[:email] 
    @mobile_number = params[:phone_number]
    @password = params[:password]
    @confirm_password = params[:confirm_password]
    
    #If all details have been filled in
    if  (@firstname != '' && @firstname) &&
        (@surname != '' && @surname) &&
        (@email != '' && @email) &&
        (@mobile_number != '' && @mobile_number) &&
        (@password != '' && @password) && 
        (@confirm_password && @confirm_password != '')
         
        #If both password match
        if(Users.confirm_password(@password,@confirm_password,$db))
            
            #If email currently not registered with another account
            if(!Users.check_same_email(@email,$db))
                
                #Create new user
                Users.new(@firstname,@surname,@email,@mobile_number,@password,$db)
                
                redirect '/' 
            else
                @unique_email = false
                erb :register
            end
         else
             @confirmation = false
             erb :register
         end
    else
        @validation = false
        erb :register
    end
end


get '/logout' do
     session.delete(:name)
     session.delete(:login)
     session.delete(:role)
     session.delete(:id)
     erb :logout
end




get "/check_all_users" do
    @list  =Users.find_all($db)
    
    erb :all_users
end

post "/check_all_users" do
    @no_results=false
    @search = params[:search]
    @list = Users.find_search(@search, $db)
    
    if (@list==[])
        @no_results=true
    end
    
    erb :all_users
end

post "/check_all_users/suspend" do
    @id=params[:ids]
    
    Users.suspend(@id,$db)
    redirect 'check_all_users'
end

post "/check_all_users/unsuspend" do
    @id=params[:idu]
    
    Users.unsuspend(@id,$db)
    redirect 'check_all_users'
end

get "/check_all_users/back" do
    redirect '/'
end

get "/check_all_users/details" do
    @id = params[:id]
    @found = Users.find_one(@id,$db)
    
    @firstname = @found[:firstname]
    @surname = @found[:surname]
    @email = @found[:email]
    @phone = @found[:phone]
    @password = @found[:password]
    @access_level = @found[:access_level] 
    
    erb :user_details
end

get "/check_all_users/details/back" do
    redirect '/check_all_users'
end

post "/check_all_users/details/set_role" do
    @id = params[:id]
    @access_level = params[:access_level]
    
    Users.set_role(@access_level, @id, $db)
    
    @found = Users.find_one(@id,$db)
    
    @firstname = @found[:firstname]
    @surname = @found[:surname]
    @email = @found[:email]
    @phone = @found[:phone]
    @password = @found[:password]
    @access_level = @found[:access_level]
    
    erb :user_details
end

get "/check_all_users/details/set_password" do
    @id = params[:id]
    
    erb :set_password
end

post "/check_all_users/details/set_password" do
    @validation = true
    
    @id = params[:id]
    @newpassword = params[:new_password]
    
   
    if @newpassword && @newpassword==""
        @validation = false
        erb :set_password
    else
      Users.change_password(@newpassword, @id, $db)
      @found = Users.find_one(@id, $db)
      
      @firstname = @found[:firstname]
      @surname = @found[:surname]
      @email = @found[:email]
      @phone = @found[:phone]
      @password = @found[:password]
      @access_level = @found[:access_level] 
      
      erb :details
    end
end

#Bookmark Part--------------------------

get "/adding_bookmarks" do
    erb :adding_bookmarks
end

post "/adding_bookmarks" do
    @validation = true
    @duplicate=false
    time = Time.new
    
    @title = params[:bm_title]
    @content = params[:bm_content]
    @description = params[:bm_description]
    @author = params[:bm_author]
    @author_id=session[:id]
    
    @date = (time.day.to_s + "/" + time.month.to_s + "/" + time.year.to_s)
    @rating = 0
    @num_rating = 0
    @reported = 0
    
    #If bookmark details have been entered
    if (@title != '' && @title) &&
       (@content != '' && @content) &&
       (@description != '' && @description)
      #If the title of the bookmark is unique
      if(!Bookmark.duplicate(@title,$db)) 
       Bookmark.new(@title, @content, @description, @author,@author_id, @date, @rating, @num_rating, @reported, $db)
       redirect "/"
      else
          @duplicate=true
          erb :adding_bookmarks
      end
    else 
        @validation = false
        erb :adding_bookmarks
    end
end

get "/view_bookmarks" do
    @list = Bookmark.find_all($db)
    
    erb :view_bookmarks
end

post "/view_bookmarks" do
    @no_results=false
    @search = params[:search]
    @list = Bookmark.find_search(@search, $db)
    if (@list==[])
        @no_results=true
    end
    erb :view_bookmarks
end

post "/view_bookmarks/reported" do
    @id = params[:idr]
    
    Bookmark.reported(@id, $db)
    redirect '/view_bookmarks'
end

post "/view_bookmarks/unreported" do
    @id = params[:idu]
    
    Bookmark.unreported(@id, $db)
    redirect '/view_bookmarks'
end


get "/view_bookmarks/details" do
    @id = params[:id]
    @found = Bookmark.find_one(@id,$db)
    
    @title = @found[:title]
    @author = @found[:author]
    @description = @found[:description]
    @content = @found[:content]
    @rate = @found[:rate]
    @num_of_rate = @found[:num_of_rate] 
    @date = @found[:date]
    
    erb :bookmark_details
end

get "/view_bookmarks/details/back" do
    redirect '/view_bookmarks'
end

post "/view_bookmarks/details/rating" do
    @id = params[:id]
    @rating_points = params[:rating_points].to_i
    
    Bookmark.rate(@rating_points, @id, $db)
    
    @found = Bookmark.find_one(@id,$db)
    
    @title = @found[:title]
    @author = @found[:author]
    @description = @found[:description]
    @content = @found[:content]
    @rate = @found[:rate]
    @num_of_rate = @found[:num_of_rate] 
    @date = @found[:date] 
    
    erb :bookmark_details
end

post "/view_bookmarks/details/delete" do
    @id = params[:id]
    
    Bookmark.delete(@id, $db)
    redirect '/view_bookmarks'
end

get "/my_bookmarks" do
    @id=session[:id]
    @list = Bookmark.find_my_bookmark(@id,$db)
    erb :my_bookmarks
end


get "/my_bookmarks/edit" do
    @id=params[:id]
    @found=Bookmark.find_one(@id,$db)
    @title = @found[:title]
    @author = @found[:author]
    @description = @found[:description]
    @content = @found[:content]  
    erb :edit
end

post"/my_bookmarks/edit" do
    @validation=true
    @same=false
    @duplicate=false
    @id=params[:id]
    @title = params[:title]
    @author = params[:author]
    @description = params[:description]
    @content = params[:content]  
    if (@title != '' && @title) &&
       (@content != '' && @content) &&
       (@description != '' && @description)
      if(!Bookmark.not_change(@id,@title,@author,@description,@content,$db))
        if(!Bookmark.duplicate(@title,$db))
           Bookmark.update(@id,@title ,@author ,@description,@content,$db)
           redirect "/my_bookmarks"
        else
             @duplicate=true
             erb :edit
        end
      else
           @same=true
           erb :edit
      end
    else
         @validation=false
         erb :edit
    end
end

post "/my_bookmarks/edit/delete" do
  @id=params[:id]
  Bookmark.delete(@id,$db)
  redirect"/my_bookmarks"
end


