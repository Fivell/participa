require 'minitest/hooks/test'

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  include Minitest::Hooks

  def with_verifications(presential: true, sms: true)
    prev_presential = available_features["verification_presencial"]
    prev_sms = available_features["verification_sms"]

    available_features["verification_presencial"] = presential
    available_features["verification_sms"] = sms

    yield
  ensure
    available_features["verification_presencial"] = prev_presential
    available_features["verification_sms"] = prev_sms
  end
end
