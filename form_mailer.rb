require 'sinatra'
require 'pony'

set :protection, :origin_whitelist => allowed_domains

get '/' do
  halt 401, 'sorry.'
end

post '/mail' do
  if valid_domain?
    send_email
  end

  if !params[:redirect_to].nil?
    redirect params[:redirect_to]
  else
    redirect back
  end
end

private

def allowed_domains
  ENV['FORM_MAILER_ALLOWED_DOMAINS'].to_s.split(',')
end

def valid_domain?
  ENV['FORM_MAILER_ALLOWED_DOMAINS'].include? request.referrer
end

def send_email
  Pony.mail(
    to: ENV['FORM_MAILER_TO'],
    from: from_email,
    subject: subject,
    via: :smtp,
    body: message,
    via_options: {
      address: ENV['SMTP_ADDRESS'],
      port: ENV['SMTP_PORT'],
      user_name: ENV['SMTP_USERNAME'],
      password: ENV['MANDRILL_APIKEY']
    }
  )
end

def subject
  params[:subject] || "Here's an email!"
end

def from_email
  params[:email] || 'noclue@person.net'
end

def message
  params[:message] || 'No content'
end
