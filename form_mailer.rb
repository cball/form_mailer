require 'sinatra'
require 'pony'

set :protection, :origin_whitelist => Proc.new {allowed_domains}

get '/' do
  halt 401, 'sorry.'
end

get '/healthcheck' do
  'ok'
end

post '/mail' do
  if allowed_domain?
    send_email
    redirect_to_specified_or_back
  else
    return redirect back
  end
end

def allowed_domains
  ENV['FORM_MAILER_ALLOWED_DOMAINS'].to_s.split(',')
end

private

def allowed_domain?
  allowed_domains.include? host_for(request.referrer)
end

def host_for(uri)
  URI(uri).host
end

def send_email
  Pony.mail(
    to: ENV['FORM_MAILER_TO'],
    from: from,
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

def redirect_to_specified_or_back
  if !params[:redirect_to].nil? && redirect_to_is_allowed_domain?
    redirect params[:redirect_to]
  else
    redirect back
  end
end

def redirect_to_is_allowed_domain?
  allowed_domains.include? host_for(params[:redirect_to])
end

def subject
  params[:subject] || "Here's an email!"
end

def from
  "#{from_name} <#{from_email}>"
end

def from_email
  params[:email] || "noclue@person.net"
end

def from_name
  params[:name] || "Unknown"
end

def message
  params[:message] || "No content"
end
