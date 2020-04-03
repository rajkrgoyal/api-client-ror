# frozen_string_literal: true

# It calls registration, user profile update services
class RegistrationsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create]

  def new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @result = @api_service.register(user_params)
    if @result['code'].zero?
      set_session
    else
      render 'new'
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @result = @api_service.update_me(user_params)
    if @result['code'].zero?
      session['user'] = @result['data']['user']
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.permit(:email, :password, :first_name, :last_name)
  end
end
