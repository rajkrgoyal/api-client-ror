# frozen_string_literal: true

# Actions related to sessions, it calls authentication services
class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create]

  def new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @result = @api_service.login(session_params)
    if @result['code'].zero?
      set_session
    else
      render 'new'
    end
  end

  def links
    @result = @api_service.me
    session['user']['first_name'] = @result['data']['user']['first_name']
    render partial: 'shared/links'
  end

  def destroy
    @result = @api_service.revoke
    session['user'] = session['token'] = nil
    redirect_to root_url
  end

  private

  def session_params
    params.permit(:username, :password)
  end
end
