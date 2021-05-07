class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def send_default_pwd(user)
		@user = user
		mail(from: "no-reply <no-reply@advocate.com>", to: @user.email, subject: "Advocate Management: Your Login credentials")
	end
end
