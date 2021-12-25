require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	haml :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end

get '/Login' do
	erb :Login
end

post '/about' do
        name = params[:name]
        mail = params[:mail]
        body = params[:body]

        Pony.mail(:to => '*emailaddress*', :from => "#{mail}", :subject => "art inquiry from #{name}", :body => "#{body}")

        haml :about
end



post '/Login' do
	@user = params[:user]
	@password = params[:password]
	if @user == 'Sergey' && @password == 'VeRiTaS'
		@file = File.open("./public/users.txt", "r")
		erb :contacts
	else
		@message = "Access denied"
		erb :Login
	end
end

post '/visit' do
	@users_name = params[:users_name]
	@date_times = params[:date_times]
	@phone = params[:phone]
	@parik = params[:parik]
	@color = params[:color]

	#хэш
	hh = { :users_name => 'Введите имя',
		   :phone => 'Введите Телефон',
		   :date_times => 'Неправильная дата и время'
	}
	# Для каждой пары ключ значение
	hh.each do |key, value|
		# Если параметр пуст 
		if params[key] == ''
			# То переменной error  присвоить значение хеш
			# т.е. переменной error присвоить сообщение об ошибке
			@error = hh[key]
			# вернуть представление визит
			return erb :visit
		end

	end




	@title = "Спасибо что выбрали нас!"
	@message1 = "Dear #{@users_name}, we'll be waiting for you at #{@date_times}"
	f = File.open("./public/users.txt", "a")
	f.write "Клиент: #{@users_name}, Телефон: #{@phone}, Дата и время: #{@date_times}, Парикхмахер: #{@parik}, Цвет окрашивания: #{@color}\n"
	f.close
	erb :visit

end








