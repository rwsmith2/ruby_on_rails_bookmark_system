require 'sinatra'
require 'sinatra/reloader'
also_reload 'models/*'
require_relative 'models/users.rb'
require_relative 'models/bookmark.rb'

#If checking the system test please delete the database first 
#and type "sqlite3 database/bookmark_system.sqlite<create_databases.sql" to create a new one.
#Then type "cucumber features" to run the tests.
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
    session[:search]=false
    erb :home
end



get '/login' do
     erb :login
end

post '/login' do
   
   @validation = true
   @suspend = false
    
   @username = params[:username]
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
           session[:id_l] = @id
           
           redirect '/'
     end
   else      
      @validation = false
      erb :login
   end
end

get '/request' do
    
    erb :create_request
end

post '/request' do
    @validation = true
    @no_such_user=false
    
    @username=params[:username]
    @content=params[:content]
    
     if  (@username != '' && @username) &&
        (@content != '' && @content) 
         if(Users.check_same_username(@username,$db))
          Users.request(@username,@content,$db)
          redirect '/login'
         else
             @no_such_user=true
             erb :create_request
         end
     else   
         
         @validation=false
         erb :create_request
     end
   
    
end

get '/view_request' do
    @list=Users.find_requests($db)
    erb :view_request
end

post '/view_request/read' do
    @id=params[:idr]
    Users.mark_as_read(@id,$db)
    redirect '/view_request'
end

post '/view_request/unread' do
    @id=params[:idu]
    Users.mark_as_unread(@id,$db)
    redirect '/view_request'
end



get '/register' do

      erb :register

end

post '/register' do
    @validation = true
    @confirmation = true
    @unique_email = true
    @valid_email=true
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    
    @firstname = params[:firstname]
    @surname = params[:surname]
    @username= params[:username]
    @email = params[:email] 
    @mobile_number = params[:phone_number]
    @password = params[:password]
    @confirm_password = params[:confirm_password]
    
    #If all details have been filled in
    if  (@firstname != '' && @firstname) &&
        (@surname != '' && @surname) &&
        (@username != '' && @username) &&
        (@email != '' && @email) &&
        (@mobile_number != '' && @mobile_number) &&
        (@password != '' && @password) && 
        (@confirm_password && @confirm_password != '')
           
        #If both password match
        if(Users.confirm_password(@password,@confirm_password,$db))
           
            #If email currently not registered with another account
            if(!Users.check_same_username(@username,$db))
                
                if(@email=~VALID_EMAIL_REGEX)
                 #Create new user
                 Users.new(@firstname,@surname,@username,@email,@mobile_number,@password,$db)
                
                 redirect '/'
                else
                   @valid_email=false
                   erb :register
                end
                    
            else
                @unique_username = false
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
     session.delete(:id_l)
     erb :logout
end




get "/check_all_users" do
   if session[:search_u]==false||!session[:search_u]
     @list=Users.find_all($db)
   else
     @list= Users.find_search( session[:result_u], $db)
   end
    
   erb :all_users
end

post "/check_all_users" do
    session[:search_u]=true
    @no_results=false
    session[:result_u] = params[:search]
    @list = Users.find_search( session[:result_u], $db)    
    if ( @list==[])
        @no_results=true
    end
    
    erb :all_users
end

post "/check_all_users/suspend" do
    @id=params[:ids]
    Users.suspend(@id,$db)
    redirect "/check_all_users"
end

post "/check_all_users/unsuspend" do
    
    @id=params[:idu]
    
    Users.unsuspend(@id,$db)
    redirect '/check_all_users'
end

post "/check_all_users/back" do 
    session.delete(:search_u)
    redirect '/check_all_users'
end

get "/check_all_users/details" do
    if !session[:id_u]
     session[:id_u]= params[:id]
    end
    @id = session[:id_u]
    @found = Users.find_one(@id,$db)

    @firstname = @found[:firstname]
    @surname = @found[:surname]
    @username = @found[:username]
    @email = @found[:email]
    @phone = @found[:phone]
    @access_level = @found[:access_level] 
    
    erb :user_details
end

get "/check_all_users/details/back" do
    session.delete(:id_u)
    redirect '/check_all_users'
end

post "/check_all_users/details/set_role" do
    @id = session[:id_u]
    @access_level = params[:access_level]
    
    Users.set_role(@access_level, @id, $db)
    
    redirect"/check_all_users/details"
end

get "/check_all_users/details/set_password" do    
    erb :set_password
end

post "/check_all_users/details/set_password" do
    @validation = true
    
    @id = session[:id_u]
    @newpassword = params[:new_password]
    
   
    if @newpassword && @newpassword==""
        @validation = false
        erb :set_password
    else
      Users.change_password(@newpassword, @id, $db)
      redirect"/check_all_users/details"
    end
end

#Bookmark Part--------------------------

get "/adding_bookmarks" do
    @list=Bookmark.find_tags($db)
    erb :adding_bookmarks
end

post "/adding_bookmarks" do
    @validation = true
    @duplicate=false
    @same_tag=false
    time = Time.new
    
    @title = params[:title]
    @content = params[:content]
    @description = params[:description]
    @author = params[:author]
    @author_id=session[:id_l]
    
    @date = (time.year.to_s + "-" + time.month.to_s + "-" + time.day.to_s)
    @rating = 0
    @num_rating = 0
    @reported = 0
    
    if(params[:select_tag1]!="null")
     @tag1=params[:select_tag1]
    end
 
    if(params[:select_tag2]!="null")
     @tag2=params[:select_tag2]
    end
    
    if(params[:select_tag3]!="null")
     @tag3=params[:select_tag3]
    end
    
   #If bookmark details have been entered
    if (@title != '' && @title) &&
       (@content != '' && @content) &&
       (@description != '' && @description)
      #If the title of the bookmark is unique
      if(!Bookmark.duplicate(@title,$db))
          #If there us duplicated tags
          if((@tag1!=@tag2&&@tag1!=@tag3&&@tag2!=@tag3)||(!@tag1&&!@tag2&&!@tag3)||
                                                  ((!@tag1&&!@tag3)||(!@tag2&&!@tag3)||(!@tag2&&!@tag1)))
              
            Bookmark.new(@title, @content, @description, @author,@author_id, @date, @rating, @num_rating, 
                                                                        @reported,@tag1,@tag2,@tag3, $db)
            redirect "/"
          else
               @same_tag=true
               @list=Bookmark.find_tags($db)
               erb :adding_bookmarks
          end
      else
          @duplicate=true
          @list=Bookmark.find_tags($db)
          erb :adding_bookmarks
      end
    else 
        @validation = false
        @list=Bookmark.find_tags($db)
        erb :adding_bookmarks
    end
end

get "/view_bookmarks" do
    if session[:search_bm]==false||!session[:search_bm]
      @list = Bookmark.find_all(session[:filter_r],session[:filter_d],$db)
    else
      @list = Bookmark.find_search( session[:filter_r],session[:filter_d],session[:result_bm], $db)
    end
    erb :view_bookmarks
end

post "/view_bookmarks/back" do
    session[:search_bm]=false
    redirect '/view_bookmarks'
end

post "/view_bookmarks" do
    session[:search_bm]=true
    @no_results=false
    session[:result_bm] = params[:search]
    @list = Bookmark.find_search( session[:filter_r],session[:filter_d],session[:result_bm], $db)
     puts @list
    if (@list==[])
        puts @list
        @no_results=true
    end
    erb :view_bookmarks
end

post "/view_bookmarks/filter" do
    @choice=params[:filter]
    if @choice=="rate"
         session[:filter_r]=true
         session[:filter_d]=false
    else
       session[:filter_r]=false
       session[:filter_d]=true
    end
     redirect '/view_bookmarks'
end

post "/view_bookmarks/reset" do
     session.delete(:filter_r)
     session.delete(:filter_d)
    redirect '/view_bookmarks'
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
    if !session[:id_bm]
     session[:id_bm]= params[:id]
    end
    @id=session[:id_bm]
    @found = Bookmark.find_one(@id,$db)
    
    @title = @found[:title]
    @author = @found[:author]
    @description = @found[:description]
    @content = @found[:content]
    @rate = @found[:rate]
    @num_of_rate = @found[:num_of_rate] 
    @date = @found[:date]
    @tag1 = @found[:tag1]
    @tag2 = @found[:tag2]
    @tag3 = @found[:tag3]
    
    @number_c=Bookmark.number_of_comments(session[:id_bm],$db)
    erb :bookmark_details
end

get "/view_bookmarks/details/back" do
    session.delete(:id_bm)
    redirect '/view_bookmarks'
end

post "/view_bookmarks/details" do
    
    @rate_yourself=false
    @id = session[:id_bm]
    @rating_points = params[:rating_points].to_i
    
    if !Bookmark.own_bookmark(@id,session[:id_l],$db)
      Bookmark.rate(@rating_points, @id, $db)
      redirect '/view_bookmarks/details'
    else
       @rate_yourself=true 
       @id=session[:id_bm]
       @found = Bookmark.find_one(@id,$db)   
        
       @title = @found[:title]
       @author = @found[:author]
       @description = @found[:description]
       @content = @found[:content]
       @rate = @found[:rate]
       @num_of_rate = @found[:num_of_rate] 
       @date = @found[:date]
       @tag1 = @found[:tag1]
       @tag2 = @found[:tag2]
       @tag3 = @found[:tag3]
        
        
       @number_c=Bookmark.number_of_comments(session[:id_bm],$db)
       erb :bookmark_details
    end
end

post "/view_bookmarks/details/delete" do
    @id = params[:id]
    
    Bookmark.delete(@id, $db)
    session.delete(:id_bm)
    redirect '/view_bookmarks'
end

get "/my_bookmarks" do
    @id=session[:id_l]
    @list = Bookmark.find_my_bookmark(@id,$db)
    erb :my_bookmarks
end


get "/my_bookmarks/edit" do
    @list=Bookmark.find_tags($db)
    @id=params[:id]
    @found=Bookmark.find_one(@id,$db)
    @title = @found[:title]
    @author = @found[:author]
    @description = @found[:description]
    @content = @found[:content] 
    @tag1=@found[:tag1]
    @tag2=@found[:tag2]
    @tag3=@found[:tag3]
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
    
    if(params[:select_tag1]!="null")
     @tag1=params[:select_tag1]
    end
 
    if(params[:select_tag2]!="null")
     @tag2=params[:select_tag2]
    end
    
    if(params[:select_tag3]!="null")
     @tag3=params[:select_tag3]
    end
    
    if (@title != '' && @title) &&
       (@content != '' && @content) &&
       (@description != '' && @description)
      if(!Bookmark.not_change(@id,@title,@author,@description,@content,@tag1,@tag2,@tag3,$db))
        if(!Bookmark.change_to_duplicate(@title,@id,$db))
           Bookmark.update(@id,@title ,@author ,@description,@content,@tag1,@tag2,@tag3,$db)
           redirect "/my_bookmarks"
        else
             @duplicate=true
             @list=Bookmark.find_tags($db)
             erb :edit
        end
      else
           @same=true
           @list=Bookmark.find_tags($db)
           erb :edit
      end
    else
         @validation=false
         @list=Bookmark.find_tags($db)
         erb :edit
    end
end

post "/my_bookmarks/edit/delete" do
  @id=params[:id]
  Bookmark.delete(@id,$db)
  redirect"/my_bookmarks"
end

get "/add_comment" do
   erb :add_comment
end

post "/add_comment" do
   @validation=true
   @comment_yourself=false
   time = Time.new

   @id_bm=session[:id_bm]
   @author=params[:author]
   @content=params[:content]
   @title=params[:title]
   @date = (time.year.to_s + "-" + time.month.to_s + "-" + time.day.to_s)
   
   if (@title != '' && @title) &&
      (@content != '' && @content) &&
      (@author != '' && @author)
       if !Bookmark.own_bookmark(@id_bm,session[:id_l],$db)
        Bookmark.add_comment(@id_bm,@title,@author,@content,@date,$db)
        redirect '/view_bookmarks/details'
       else
            @comment_yourself=true
            erb :add_comment
       end
   else
       @validation=false
       erb :add_comment
   end
end

get "/view_comments" do
    @list=Bookmark.find_comments(session[:id_bm],$db)
    erb :view_comments
end


