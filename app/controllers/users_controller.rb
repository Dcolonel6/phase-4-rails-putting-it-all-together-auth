class UsersController < ApplicationController
    wrap_parameters format: []
    rescue_from ActiveRecord::RecordInvalid, with: :render_user_unprocessable_entity
     
    before_action :authorize
    skip_before_action :authorize, only: [:create]
    
    def create
        user = User.create!(user_params)
        session[:user_id] = user.id
        render json: user, status: :created
    end

    def show
        user = find_user
        render json: user, status: :created
    end

    private    
    def user_params
        params.permit(:username, :image_url, :bio, :password, :password_confirmation)
    end

    def render_user_unprocessable_entity(error_object)
        render json: {errors: error_object.record.errors.full_messages}, status: :unprocessable_entity
    end

    def authorize
        return render json: {error: "User not authenticated"}, status: :unauthorized unless session.include? :user_id
    end

    def find_user
        User.find(session[:user_id])
    end
end
