class UsersController < ApplicationController

  def initialize
    super
    @model = User
    @model_object = nil

    @white_list_params = [:username, :email, :password, :password_confirmation, :active, :avatar]

    @model_objects_path = :users_path

    @search_list = ['username', 'email']

    object_info
  end

  def delete_avatar
    user = @model.find(params[:id])
    user.remove_avatar!

    redirect_to :back
  end

end
