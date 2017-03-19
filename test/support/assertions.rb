require 'minitest/assertions'

module Minitest
  module Assertions
    #
    #  Fails unless +expected+ and +actual+ have the same items.
    #
    def assert_matches_array(expected, actual)
      assert same_items(expected, actual), same_items_message(expected, actual)
    end

    private

    def same_items_message(expected, actual)
      "Expected #{expected.inspect} and #{actual.inspect} " \
      "to have the same items"
    end

    def same_items(expected, actual)
      actual.is_a?(Enumerable) &&
        expected.is_a?(Enumerable) &&
        expected.sort == actual.sort
    end
  end
end

