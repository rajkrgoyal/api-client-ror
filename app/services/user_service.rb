# frozen_string_literal: true

# All APIs related to user
module UserService
  def change_password(params)
    HTTParty.post("#{ENV['API_URL']}/users/me/password",
                  headers: @headers,
                  body: {
                    "user": {
                      "current_password": params[:current_password],
                      "new_password": params[:password]
                    }
                  })
  end

  def update_me(params)
    HTTParty.patch("#{ENV['API_URL']}/users/me",
                   headers: @headers,
                   body: {
                     "user": {
                       "first_name": params[:first_name],
                       "last_name": params[:last_name]
                     }
                   })
  end

  def me
    HTTParty.get("#{ENV['API_URL']}/users/me",
                 headers: @headers)
  end
end
