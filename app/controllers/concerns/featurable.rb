require 'active_support/concern'

module Featurable
  extend ActiveSupport::Concern

  included do
    helper_method :verifications_enabled?,
                  :presential_verifications_enabled?,
                  :online_verifications_enabled?
  end

  def verifications_enabled?
    presential_verifications_enabled? || online_verifications_enabled?
  end

  def presential_verifications_enabled?
    Rails.application.secrets.features["verification_presencial"]
  end

  def online_verifications_enabled?
    Rails.application.secrets.features["verification_sms"]
  end
end
