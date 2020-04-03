# frozen_string_literal: true

# All APIs related to widgets
module WidgetService

  # Visible widgets with search
  def get_widgets(params)
    params['client_id'] = ENV['CLIENT_ID']
    params['client_secret'] = ENV['CLIENT_SECRET']

    api_path = if params['user_id'].present?
                 "/users/#{params['user_id']}/widgets"
               else
                 '/widgets/visible'
               end
    # user_id is not required to send in body
    params.delete(:user_id)

    # params['term'] would be searched
    HTTParty.get("#{ENV['API_URL']}#{api_path}", body: params)
  end

  # logged in user's widgets with searching
  def my_widgets(params)
    params['client_id'] = ENV['CLIENT_ID']
    params['client_secret'] = ENV['CLIENT_SECRET']

    # params['term'] would be added in body params
    HTTParty.get("#{ENV['API_URL']}/users/me/widgets",
                 headers: @headers,
                 body: params)
  end

  def create_widget(params)
    HTTParty.post("#{ENV['API_URL']}/widgets",
                  headers: @headers,
                  body: {
                    "widget": {
                      'name': params['name'],
                      'description': params['description'],
                      'kind': params['kind']
                    }
                  })
  end

  def show_widget(id)
    HTTParty.get("#{ENV['API_URL']}/widgets/#{id}",
                 headers: @headers)
  end

  def update_widget(params)
    HTTParty.put("#{ENV['API_URL']}/widgets/#{params['id']}",
                 headers: @headers,
                 body: {
                   "widget": {
                     'name': params['name'],
                     'description': params['description']
                   }
                 })
  end

  def destroy_widget(id)
    HTTParty.delete("#{ENV['API_URL']}/widgets/#{id}", headers: @headers)
  end
end
