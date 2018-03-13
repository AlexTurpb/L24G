#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'pony'
get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end

post '/contacts' do
	@user_mail = params[:user_mail]

	if @user_mail != "" #&& @user_mail.inlude? "@"
	 Pony.mail({
		  :to => @user_mail,
		  :subject => 'Hello',
		  :body => 'World',
		  :via => :smtp,
		  :via_options => {
		    :address              => 'smtp.gmail.com',
		    :port                 => '587',
		    :enable_starttls_auto => true,
		    :user_name            => 'example@mail.com',
		    :password             => 'p@55w0rd',
		    :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
		    :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
		  }
		})

		@info = "Subscribed"
		return erb :contacts
	else
        @error = "Something wrong"
        return erb :contacts
    end
end

post '/visit' do
	@username = params[:username].capitalize
	@user_phone = params[:user_phone]
	@user_date = params[:user_date]
	@prefered_barber = params[:prefered_barber]
	@color = params[:color]

	# hash
	hh = {:username => 'Enter name',
			:user_phone => 'Enter phone',
			:user_date => 'Enter date'
		}
	
	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ""
		return erb :visit
	else		
		@info = "Success! <b><i>#{@username}.</b></i> We've got your Phone: <b><i>#{@user_phone}.</b></i> <b><i>#{@prefered_barber}</b></i> waiting for you at: <b><i>#{@user_date}.</b></i> <b><i>#{@color}</b></i> paint is available."
		return erb :visit
		
		users_log = File.open './public/users.txt', 'a'
		users_log.write "User: #{@username} Phone: #{@user_phone} Date: #{@user_date} Barber: #{@prefered_barber} Paint: #{@color}\n"
		users_log.close
	end
end

