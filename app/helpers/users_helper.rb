module UsersHelper

  def object_variables
    user_variables = {}
    user_variables[:icon] = 'user'
    user_variables[:title] = 'Users'
    user_variables[:object_name] = 'User'
    #user_variables[:object_controller] = UsersController
    user_variables[:form_path] = 'users/form'
    user_variables[:status_form_path] = status_users_path

    user_variables
  end

end
