class ApplicationController < ActionController::Base
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    
    include Pagy::Backend

    private
  
    def render_404
      render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
    end
  end