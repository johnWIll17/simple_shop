class UsersController < ApplicationController

  def initialize
    super
    @model = User
    @model_object = nil

    @white_list_params = [:username, :email, :password, :password_confirmation, :active]

    @model_objects_path = :users_path

    @search_list = ['username', 'email']

    object_info
  end

end
