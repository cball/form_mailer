form_mailer
===========

Simple Sinatra form mailer to process and email contact forms. I threw this together to send email from some of my static sites.

### Clone the repo and create the heroku app to run it

```bash
git clone git@github.com:cball/form_mailer.git
```

```bash
heroku apps:create cool-mailer-app
```

## Add an smtp addon (I use mandrill)
heroku addons:add mandrill

## Configure

The following ENV variables should be set on on heroku:
FORM_MAILER_ALLOWED_DOMAINS
FORM_MAILER_TO
SMTP_ADDRESS
SMTP_PASSWORD
SMTP_PORT
SMTP_USERNAME

FORM_MAILER_ALLOWED_DOMAINS is a comma separated list of domains you want to allow to post to the app
FORM_MAILER_TO is the email address or list of email addresses you'd like to send messages to

```bash
heroku config:set FORM_MAILER_ALLOWED_DOMAINS=mysite.com FORM_MAILER_TO=myemail@mysite.com SMTP_ADDRESS=smtp.mandrillapp.com SMTP_USERNAME=(username from MANDRILL_USERNAME) SMTP_PASSWORD=(password from MANDRILL_APIKEY) SMTP_PORT=587
```

### Push it up

```bash
git push heroku
```

## Create a contact form
Point your email form on mysite.com to post to cool-mailer-app.heroku.com/mail with any combination of the following info:
  
```html
<input type="text" name="subject" value="my email subject" />
<input type="text" name="redirect_to" value="http://mysite.com/thanks" />
<input type="text" name="name" />
<input type="email" name="email" />
<textarea name="message"></textarea>
```
