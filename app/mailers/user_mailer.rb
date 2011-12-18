class UserMailer < ActionMailer::Base
  default from: "server@game.akshayjoshi.com"

  def welcome_email(user)
    @user = user
    @link = login_path
    mail(:to => user.email, :subject => "Thank you for registering!")
  end
end
