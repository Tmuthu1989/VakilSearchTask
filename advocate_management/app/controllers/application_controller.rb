class ApplicationController < ActionController::Base
	include ActionView::Helpers::NumberHelper
  protect_from_forgery with: :exception, prepend: true
  layout :get_layout
  before_action :authenticate_user!
	before_action :configure_permitted_parameters, if: :devise_controller?
	helper_method :session_id
	
  protected

  	def session_id
  		request.session_options[:id]
  	end

	  def configure_permitted_parameters
	    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone_number, :mobile_number, :date_of_birth, :role, :advocate_number, {state_ids: []}])
	    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone_number, :mobile_number, :date_of_birth, :role, :advocate_number, {state_ids: []}])
	  end

  private

		def get_layout
		  if current_user.present?
        "application"
      else
        'auth'
      end
		end
end
