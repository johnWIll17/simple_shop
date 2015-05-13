class UsersController < ApplicationController

  def initialize
    super
    @model = User
    @primary_key = :user_ids
    @model_object = nil

    @white_list_params = [:username, :email, :password, :password_confirmation, :active]
    @object_require = :user

    @model_objects_path = :users_path
    @model_new_path = :new_user_path

    @search_list = ['username', 'email', 'active']
  end

end
