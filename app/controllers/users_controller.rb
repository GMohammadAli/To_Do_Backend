class UsersController < ApplicationController
    skip_before_action :authenticate_request, only: [:create]
    before_action :set_user, only: [:show, :destroy]

    #GET /users
    def index
        @users = User.all
        render json: @users, status: :ok
    end

    # GET /users/{username}
    def show
        token = jwt_encode(user_id: @user.id)
        render json: {user: @user, token: token }, status: :ok
    end 

    # POST /users
    def create 
        @user = User.new(user_params)
        if @user.save
            token = jwt_encode(user_id: @user.id)
            render json: {user: @user, token: token }, status: :created
        else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    # PUT /users/{username}
    def update
        @user = User.find(params[:id])
        unless @user.update(user_params)
            render   json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    # DELETE /users/{username}
    def destroy 
        @tasks = Task.all
        @tasks.where(user_id: @user.id).destroy_all
        @user.destroy

        render  json: { message:"User Deleted" }
    end

    private
       def user_params
        params.permit(:name, :username, :email, :password)
       end
       
       def set_user
        @user = User.find(params[:id])
       end

end
