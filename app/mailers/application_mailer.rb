class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("DEV_GMAIL_USERNAME")
  layout "mailer"
end
