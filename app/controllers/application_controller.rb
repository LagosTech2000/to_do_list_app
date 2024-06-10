class ApplicationController < ActionController::Base
    include Pagy::Backend
    
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    protect_from_forgery with: :exception
    before_action :authenticate_user!
    
    
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :set_conversation_data
    
    
    def cancel_form
    
      render turbo_stream: turbo_stream.update(
        "new_conversation_#{current_user.id}",
         ""
  
        )
  
    end
  
    def cancel_modal
      
      render turbo_stream: turbo_stream.update(
        "modal_#{current_user.id}",
         ""
  
        )
  
    end

    protected
    
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username])
      devise_parameter_sanitizer.permit(:sign_up, keys: [:avatar])
      devise_parameter_sanitizer.permit(:account_update, keys: [:avatar])
    end
    
    private

    def set_conversation_data
      if (current_user)
         @messages_notif = Message.where(conversation_id: current_user.conversation_users.pluck(:conversation_id)).where.not(user_id: current_user.id)
      end
    end

    def render_404
      render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
    end
end