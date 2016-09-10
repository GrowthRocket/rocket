class ApplicationMailer < ActionMailer::Base
  default from: "order-notify@mail.runner2sun.me"
  layout "mailer"
end
