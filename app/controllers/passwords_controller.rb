# frozen_string_literal: true

# It calls password related services
class PasswordsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create]

  def new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @result = @api_service.reset_password(password_params)
    if @result['code'].zero?
      flash[:notice] = @result['message']
      redirect_to root_url
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
    if password_params[:password] != password_params[:confirm_password]
      @error = "New password and confirm password don't match."
      render 'edit'
    else
      @result = @api_service.change_password(password_params)
      render_or_redirect('edit')
    end
  end

  private

  def password_params
    params.permit(:email, :current_password, :password,
                  :confirm_password, :reset_password_token)
  end
end
