class TestMailer < ApplicationMailer
  default from: 'rehabilis.site <noreply@rehabilis.site>'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.test_mailer.test.subject
  #
  def test
    @greeting = "Hi"

    mail to: "ne300153@senshu-u.jp"
  end
end
