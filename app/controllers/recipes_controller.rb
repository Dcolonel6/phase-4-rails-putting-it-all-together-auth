class RecipesController < ApplicationController
    wrap_parameters format: []
    rescue_from ActiveRecord::RecordInvalid, with: :render_user_unprocessable_entity
    before_action :authorize

    def index 
        recipes = Recipe.all
        render json: recipes, status: :created
    end

    def create 
        new_recipe = recipes_params
        new_recipe[:user_id] = session[:user_id]
        created_recipe = Recipe.create!(new_recipe)
        render json: created_recipe, status: :created
    end

    private
    def authorize
        return render json: {errors: ["User not authenticated"]}, status: :unauthorized unless session.include? :user_id
    end

    def recipes_params
        params.permit(:title, :instructions, :minutes_to_complete, :user_id)
    end

    def render_user_unprocessable_entity(invalid)
        render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end
end
