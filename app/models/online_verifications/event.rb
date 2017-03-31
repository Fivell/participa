module OnlineVerifications
  class Event < ApplicationRecord
    belongs_to :verified, class_name: 'User'

    def self.last_was_upload?
      order(created_at: :asc).last.is_a?(Upload)
    end

    def self.last_was_report?
      order(created_at: :asc).last.is_a?(Report)
    end
  end
end
