require "json"
require "sinatra"
require "sinatra/activerecord"

require "./config/database"

Dir['./app/models/*.rb'].each { |f| require f }

class App < Sinatra::Base
  get "/" do
    "Hello World!"
  end
end
