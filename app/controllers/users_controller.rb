class UsersController < ApplicationController
  skip_before_action :user_access, only: [:show, :edit, :update]
  #before_action :user_access, except: [:edit, :update]

  def initialize
    super
    @model = User
    @model_object = nil

    @white_list_params = [:username, :email, :password, :password_confirmation, :active, :avatar]

    @model_objects_path = :users_path

    @search_list = ['username', 'email']

    object_info
  end

  def show
    @model_object = @model.find(params[:id])
  end

  def edit
    unless current_user.admin?
      if current_user.id != params[:id].to_i
        flash[:danger] = "You don't have permission to access that page!"
        redirect_to user_path(current_user)
      end
    end
  end


  def delete_avatar
    user = @model.find(params[:id])
    user.remove_avatar!

    redirect_to :back
  end

end
