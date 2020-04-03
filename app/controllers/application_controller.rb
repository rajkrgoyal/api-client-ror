# frozen_string_literal: true

# Superclass for all other controllers
class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  require 'api_service'

  before_action :init_api_service, :authenticate_user!

  def init_api_service
    token = session['token']
    auth = "#{token['token_type']} #{token['access_token']}" if token.present?
    @api_service = ApiService.new(
      'Authorization': auth
    )
  end

  private

  # it's calling after refresh token, sign up and login
  def set_session
    session['token'] = @result['data']['token']
    current_user
  end

  def current_user
    init_api_service
    @result = @api_service.me
    if @result.present? && @result['code'].zero?
      session['user'] = @result['data']['user']
    else
      flash[:error] = @result['message']
      session['user'] = session['token'] = nil
      redirect_to root_url
    end
  end

  def authenticate_user!
    refresh_token

    return unless session['token'].blank?

    flash[:error] = 'You must be logged in to view this page.'
    redirect_to root_url
  end

  def refresh_token
    token_expire_time = session['token']['created_at'] + session['token']['expires_in']

    # Refresh token expiring before 60 seconds
    return if Time.at(token_expire_time) - Time.now > 60

    # Hit refresh token API before token expire
    @result = @api_service.refresh_token(session['token']['refresh_token'])
    session['token'] = @result['data']['token']

    # update @api_service with new auth token
    init_api_service
  end

  def render_or_redirect(action)
    if @result && @result['code'].zero?
      flash[:notice] = @result['message']
      redirect_to root_url
    else
      @error = @result['message']
      render action
    end
  end
end
