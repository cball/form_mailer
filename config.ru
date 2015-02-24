use Rack::Cors do
  allow do
    origins '*'
    resource '*', :headers => :any,  :methods => [:get, :post, :delete, :put, :options]
  end
end

require './form_mailer'
run Sinatra::Application
