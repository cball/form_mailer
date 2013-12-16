require 'sinatra'
require 'pony'

set :protection, :origin_whitelist => [ENV['FORM_MAILER_ALLOWED_DOMAINS'].split(',')]

get '/' do
  halt 401, 'sorry.'
end

post '/mail' do
  Pony.mail to: ENV['FORM_MAILER_TO'], from: params[:email] || 'noclue@person.net', subject: params[:subject] || "Here's an email!"

  if !params[:redirect_to].nil?
    redirect params[:redirect_to]
  else
    redirect back
  end
end
