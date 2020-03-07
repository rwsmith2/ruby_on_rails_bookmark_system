require 'sinatra'
require 'sinatra/reloader'
also_reload 'models/*'
require_relative 'models/users.rb'


set :bind, '0.0.0.0'
enable :sessions


get '/' do
   if Users.checkForLogin(session[:name])
    @name=session[:name]
   else
    @name=''
   end
    erb :home
end



get '/login' do
   if !Users.checkForLogin(session[:name])
     erb :templateLogin
   else
       redirect '/?alert1'
   end
end

post '/login' do
   @validation=true
   @name=params[:name]
   @password=params[:password]
   if Users.validation(@name,@password)
       session[:name]=params[:name]
        
       redirect '/'
   else
       @validation=false
       erb :templateLogin
   end
end

get '/register' do
    if !Users.checkForLogin(session[:name])
      erb :register
    else
      redirect '/?alert1'
    end
end

post '/register' do
    @validation=true
    @firstname=params[:firstname].strip
    @surname=params[:surname]
    @email=params[:email] 
    @mobile_number=params[:phone_number]
    @password=params[:password].strip
    Users.new(@firstname,@surname,@email, @mobile_number,@password)
    @firstname_ok=!@firstname.nil? && @firstname=''
    if  @firstname_ok
     redirect '/'
    else
      @validation=false
      erb :register
    end
end


get '/logout' do
    if Users.checkForLogin(session[:name])
     session.delete(:name)
     erb :logout
    else
     redirect '/?alert2'
    end
end


    


