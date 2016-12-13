module Participa
  module Test
    module LoginHelpers
      include Capybara::DSL

      def login user
        post_via_redirect user_session_path, 'user[login]' => user.email, 'user[password]' => user.password
      end
    end
  end
end
