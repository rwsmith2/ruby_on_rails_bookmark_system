require 'sinatra'
require 'sinatra/reloader'
require_relative 'models/recruit.rb'


set :bind, '0.0.0.0'
enable :sessions

$login=false
get '/' do
   if $login
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
   @id=params[:id]
   @name=params[:name]
   if Recruit.validation(@id,@name)
       puts Recruit.validation(@id,@name)
       session[:name]=params[:name]
        $login=true
       redirect '/'
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
    @id=params[:id].strip
    @name=params[:name].strip
    @gender=params[:gender]
    @age=params[:age]
    Recruit.new(@id,@name,@gender,@age)
    @id_ok=!@id.nil? && @id=''
    @name_ok=!@name.nil? && @name=''
    if @id_ok&&@name_ok
     redirect '/'
    else
      @validation=false
      erb :register
    end
end


get '/logout' do
    $login=false
    erb :logout
end


    


