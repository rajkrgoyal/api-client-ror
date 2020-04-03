# frozen_string_literal: true

# Multiple Inheritence here
# ApiService would be instantiate in controller
class ApiService
  include AuthenticationService
  include UserService
  include WidgetService

  def initialize(headers)
    @headers = headers
  end
end
