class ConfirmationMailer < ActionMailer::Base
  layout "email"
  default from: Rails.application.secrets.default_from_email

  def retry_confirmation_instructions(user)
    @user = user
    @token = user.confirmation_token

    subject = 'Un País En Comú - Re-envío de la confirmación / ' \
              'Re-enviament de la confirmació'

    mail(to: user.email, subject: subject)

    user.update!(confirmation_sent_at: Time.zone.now)
  end
end
