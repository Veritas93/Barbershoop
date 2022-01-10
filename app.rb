require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists? db, name
	db.execute('select * from Barbers where name=?', [name]).length > 0
end

def seed_db db, barbers
	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute 'insert into Barbers (name) values (?)', [barber]
		end
	end
end

def get_db
	return SQLite3::Database.new 'barbershop.db'
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS
	 	"Users" 
	 	(
	 		"id" INTEGER PRIMARY KEY AUTOINCREMENT,
	 	 	"username" TEXT,
	 	 	"phone" TEXT,
	  	 	"date_stump" TEXT,
	  	 	"barber" TEXT,
	    	 	"color" TEXT
	 	)'
	db.execute 'CREATE TABLE IF NOT EXISTS
	 	"Barbers" 
	 	(
	 		"id" INTEGER PRIMARY KEY AUTOINCREMENT,
	 	 	"name" TEXT
	 	 	
	 	)'
	seed_db db, ['Ксения', 'Марина', 'Наталья'] 	
end
	

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	haml :about
end

get '/admin' do
	erb :admin
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
		db = get_db
		@results = db.execute 'select * from Users order by id desc'
		erb :admin
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
	db = get_db
	db.execute 'insert into 
		Users 
		(
			username,
			phone,
			date_stump,
			barber,
			color
		)
		values( ?,?,?,?,? )', [@users_name, @phone, @date_times, @parik, @color]



	@title = "Спасибо что выбрали нас!"
	@message1 = "Dear #{@users_name}, we'll be waiting for you at #{@date_times}"
	f = File.open("./public/users.txt", "a")
	f.write "Клиент: #{@users_name}, Телефон: #{@phone}, Дата и время: #{@date_times}, Парикхмахер: #{@parik}, Цвет окрашивания: #{@color}\n"
	f.close
	erb :visit

end









