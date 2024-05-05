class HomeController < ApplicationController
    before_action :authenticate_user!, except: [:about]
    def index
        @tasks = Task.where("tasks.user_id = ?", current_user.id)
      end      
    def about
    end
end
