class SessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]

  def new
  end

  def create
    user = login(params[:email], params[:password], params[:remember_me])
    if user
      flash[:success] = 'Welcome back!'
      redirect_to categories_path
    else
      flash[:danger] = 'Email or password is invalid. Please check out!'
      render :new
    end
  end

  def destroy
    logout
    flash[:success] = 'Sign out!'
    redirect_to log_in_path
  end

end
