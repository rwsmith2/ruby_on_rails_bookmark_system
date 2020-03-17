require 'sinatra'
require 'sinatra/reloader'
also_reload 'models/*'
require_relative 'models/users.rb'
require_relative 'models/bookmark.rb'


set :bind, '0.0.0.0'
enable :sessions

$db = SQLite3::Database.new 'database/bookmark_system.sqlite'

get '/' do
   if Users.checkForLogin(session[:login])
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
   @validation=true
   @suspend=false
   @username=params[:email]
   @password=params[:password]  
   if Users.validation(@username,@password, $db)
     @id=Users.findId(@username,@password)
     if Users.underSuspend(@id)
       @suspend=true
       erb :login
     else
       session[:login]=true 
       @id=Users.findId(@username,@password, $db)
       session[:role]=Users.checkRole(@id, $db)
       session[:name]=Users.findName(@id, $db)
       redirect '/'
     end
   else      
      @validation=false
      erb :login
   end
  
end

get '/register' do

      erb :register

end

post '/register' do
    @validation=true
    @confirmation=true
    @firstname=params[:firstname]
    @surname=params[:surname]
    @email=params[:email] 
    @mobile_number=params[:phone_number]
    @password=params[:password]
    @confirm_password=params[:confirm_password]
    if  (@firstname!=''&&@firstname)&&(@surname!=''&&@surname)&&(@email!=''&&@email)&&
           (@mobile_number!=''&&@mobile_number)&&(@password!=''&&@password)&&(@confirm_password&&@confirm_password!='')
     if(Users.confirmPassword(@password,@confirm_password, $db))
      Users.new(@firstname,@surname,@email,@mobile_number,@password, $db)
      redirect '/'
     else
         @confirmation=false
         erb :register
     end
    else
      @validation=false
      erb :register
    end
end


get '/logout' do
     session.delete(:name)
     session.delete(:login)
     session.delete(:role)
     erb :logout
end




get "/check_all_users" do
    @list=Users.findAll($db)
    erb :all_users
end

post "/check_all_users" do
    @search=params[:search]
    @list=Users.findSearch(@search, $db)
    puts @list
    erb :all_users
end

post "/check_all_users/suspend" do
    
    @id=params[:ids]
    Users.suspend(@id, $db)
    redirect 'check_all_users'
end

post "/check_all_users/unsuspend" do
   
    @id=params[:idu]
    Users.unsuspend(@id, $db)
    redirect 'check_all_users'
end

get "/check_all_users/back" do
    redirect '/'
end

get "/check_all_users/details" do
    @id=params[:id]
    @found=Users.findOne(@id, $db)
    @firstname=@found[:firstname]
    @surname=@found[:surname]
    @email=@found[:email]
    @phone=@found[:phone]
    @password=@found[:password]
    @access_level=@found[:access_level]  
    erb :details
end

get "/check_all_users/details/back" do
    redirect '/check_all_users'
end

post "/check_all_users/details/set_role" do
    @id=params[:id]
    @access_level=params[:access_level]
    Users.setRole(@access_level,@id, $db)
    @found=Users.findOne(@id, $db)
    @firstname=@found[:firstname]
    @surname=@found[:surname]
    @email=@found[:email]
    @phone=@found[:phone]
    @password=@found[:password]
    @access_level=@found[:access_level] 
    erb :details
end

get "/check_all_users/details/set_password" do
     @id=params[:id]
    erb :set_password
end

post "/check_all_users/details/set_password" do
    @validation=true
    @id=params[:id]
    @newpassword=params[:new_password]
    if  @newpassword&&@newpassword==""
        @validation=false
        puts "sds"
        erb :set_password
    else
      Users.changePassword(@newpassword, @id, $db)
      @found=Users.findOne(@id, $db)
      @firstname=@found[:firstname]
      @surname=@found[:surname]
      @email=@found[:email]
      @phone=@found[:phone]
      @password=@found[:password]
      @access_level=@found[:access_level] 
      erb :details
    end
end

get "/adding_bookmarks" do
    erb :adding_bookmarks
end

post "/adding_bookmarks" do
    time = Time.new
    @title=params[:bm_title]
    @content=params[:bm_content]
    @descriptiont=params[:bm_description]
    @author=params[:bm_author]
    @date= (time.day.to_s + "/" + time.month.to_s + "/" + time.year.to_s)
    @rating=0
    @num_rating=0
    @reported=false
    
    if  @title!=''||@content!=''||@descriptiont!=''||@author!=''||@date!=''||@rating!=''||@num_rating!=''||@reported!=''
        @id = @title + "_" + @date
        Bookmark.new(@id,@title,@content,@descriptiont,@author,@date,@rating,@num_rating,@reported)
    else 
        "Invalid"
        redirect "/adding_bookmarks"
    end
end






