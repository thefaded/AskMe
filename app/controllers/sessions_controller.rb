class SessionsController < ApplicationController
  before_action :already_user, only: [:new, :create]

  def new
  end

  def create
    @user = User.authenticate(params[:email], params[:password])

    if @user.present?
      session[:user_id] = @user.id
      redirect_to root_url, flash: { success: 'User authenticated!' }
    else
      flash.now[:danger] = 'Wrong password or email'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, flash: { success: 'You are log outed!' }
  end

  private
  def already_user
    reject_user if current_user.present?
  end
end
