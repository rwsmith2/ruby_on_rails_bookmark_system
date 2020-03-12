require 'sinatra'
require 'sinatra/reloader'
also_reload 'models/*'
require_relative 'models/users.rb'


set :bind, '0.0.0.0'
enable :sessions


get '/' do
   if Users.checkForLogin(session[:login])
    @name=session[:name]
   else
    @name=''
   end
    erb :home
end



get '/login' do
     erb :templateLogin
end

post '/login' do
   @validation=true
   @suspend=false
   @username=params[:email]
   @password=params[:password]  
   if Users.validation(@username,@password)
     @id=Users.findId(@username,@password)
     if Users.underSuspend(@id)
       @suspend=true
       erb :templateLogin
     else
       session[:login]=true 
       @id=Users.findId(@username,@password)
       session[:role]=Users.checkRole(@id)
       session[:name]=Users.findName(@id)
       redirect '/'
     end
   else      
      @validation=false
      erb :templateLogin
   end
  
end

get '/register' do

      erb :register

end

post '/register' do
    @validation=true
    @firstname=params[:firstname]
    @surname=params[:surname]
    @email=params[:email] 
    @mobile_number=params[:phone_number]
    @password=params[:password]
    if  (@firstname!=''&&@firstname)||(@surname!=''&&@surname)||(@email!=''&&@email)||
           (@mobile_number!=''&&@mobile_number)||(@password!=''&&@password)
     Users.new(@firstname,@surname,@email,@mobile_number,@password)
     redirect '/'
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
    @list=Users.findAll()
    erb :all_users
end

post "/check_all_users/suspend" do
    
    @id=params[:ids]
    Users.suspend(@id)
    redirect 'check_all_users'
end

post "/check_all_users/unsuspend" do
   
    @id=params[:idu]
    Users.unsuspend(@id)
    redirect 'check_all_users'
end

get "/check_all_users/back" do
    redirect '/'
end

get "/check_all_users/details" do
    @id=params[:id]
    @found=Users.findOne(@id)
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
    Users.setRole(@access_level,@id)
    @found=Users.findOne(@id)
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
      Users.changePassword(@newpassword,@id)
      @found=Users.findOne(@id)
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
    @title=params[:bm_title]
    @content=params[:bm_content]
    @descriptiont=params[:bm_description]
    @authort=params[:bm_author]
    @date=params[:bm_date]
    @rating=params[:bm_rating]
    @num_rating=params[:bm_num_of_rating]
    @reported=params[:bm_reported]
    
    if  @title!=''||@content!=''||@descriptiont!=''||@authort!=''||@date!=''||@rating!=''||@num_rating!=''||@reported!=''
        @id = @title + "_" + @date
        Bookmark.new(@id,@title,@content,@descriptiont,@authort,@date,@rating,@num_rating,@reported)
    else 
        "Invalid"
        redirect "/adding_bookmarks"
    end
end






