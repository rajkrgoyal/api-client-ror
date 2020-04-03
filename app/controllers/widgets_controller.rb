# frozen_string_literal: true

# Actions related to widgets, it calls widget services
class WidgetsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    result = @api_service.get_widgets(widget_params)
    return unless result.present? && result['code'].zero?

    @widgets = result['data']['widgets']
  end

  def my_widgets
    params = {term: widget_params[:my_term]}
    result = @api_service.my_widgets(params)
    if result.present? && result['code'].zero?
      @widgets = result['data']['widgets']
    end
    render action: 'index'
  end

  def new
    # Let's make hidden as default
    @kind = 'hidden'
  end

  def create
    @result = @api_service.create_widget(widget_params)
    if @result.present? && @result['code'].zero?
      flash[:notice] = 'Widget successfully created.'
      redirect_to my_widgets_url
    else
      @name = widget_params[:name]
      @description = widget_params[:description]
      render action: 'new'
    end
  end

  def edit
    @result = @api_service.show_widget(widget_params['id'])
    @name = @result['data']['widget']['name']
    @description = @result['data']['widget']['description']
    @kind = @result['data']['widget']['kind']
  end

  def update
    @result = @api_service.update_widget(widget_params)
    if @result.present? && @result['code'].zero?
      @widgets = @result['data']['widgets']
      flash[:notice] = 'Widget successfully update.'
      redirect_to my_widgets_url
    else
      @name = widget_params[:name]
      @description = widget_params[:description]
      render action: 'edit'
    end
  end

  def destroy
    @result = @api_service.destroy_widget(widget_params['id'])
    flash[:notice] = if @result['code'].zero?
                       'Widget successfully deleted.'
                     else
                       @result['message']
                     end
    redirect_to my_widgets_url
  end

  private

  def widget_params
    params.permit(:id, :term, :my_term, :user_id, :name, :description, :kind)
  end
end
