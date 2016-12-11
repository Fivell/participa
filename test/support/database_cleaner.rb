DatabaseCleaner.clean_with(:truncation)
DatabaseCleaner.strategy = :truncation

module ActiveSupport
  #
  # Base class for unit testing
  #
  class TestCase
    self.use_transactional_fixtures = false

    def setup
      DatabaseCleaner.start
    end

    def teardown
      DatabaseCleaner.clean
    end
  end
end
