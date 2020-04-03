# frozen_string_literal: true

# All APIs related to authentication
module AuthenticationService
  def register(params)
    user = { "first_name": params[:first_name],
             "last_name": params[:last_name],
             "password": params[:password],
             "email": params[:email] }

    HTTParty.post("#{ENV['API_URL']}/users",
                  body: {
                    "client_id": ENV['CLIENT_ID'],
                    "client_secret": ENV['CLIENT_SECRET'],
                    "user": user
                  })
  end

  def login(params)
    HTTParty.post("#{ENV['APP_HOST']}/oauth/token",
                  body: {
                    "grant_type": 'password',
                    "client_id": ENV['CLIENT_ID'],
                    "client_secret": ENV['CLIENT_SECRET'],
                    "username": params[:username],
                    "password": params[:password]
                  })
  end

  def refresh_token(refresh_token)
    HTTParty.post("#{ENV['APP_HOST']}/oauth/token",
                  body: {
                    "grant_type": 'refresh_token',
                    "refresh_token": refresh_token,
                    "client_id": ENV['CLIENT_ID'],
                    "client_secret": ENV['CLIENT_SECRET']
                  })
  end

  def revoke
    HTTParty.get("#{ENV['API_URL']}/oauth/revoke",
                 headers: @headers)
  end

  def reset_password(params)
    HTTParty.post("#{ENV['API_URL']}/users/reset_password",
                  body: {
                    "client_id": ENV['CLIENT_ID'],
                    "client_secret": ENV['CLIENT_SECRET'],
                    "user": {
                      "email": params[:email]
                    }
                  })
  end
end
