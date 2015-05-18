class SessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]
  skip_before_action :user_access, only: [:new, :destroy]

  def new
    if current_user
      if current_user.admin?
        redirect_to categories_path
      else
        redirect_to user_path(current_user)
      end
    end
  end

  def create
    user = login(params[:email], params[:password])
    if user
      if user.admin?
        flash[:success] = 'Welcome back Admin!'
        redirect_to categories_path
      else
        flash[:success] = "Welcome back #{user.username}"
        redirect_to user_path(user)
      end
    else
      render :new
    end
  end

  def destroy
    logout
    flash[:success] = 'Sign out!'
    redirect_to log_in_path
  end

end
