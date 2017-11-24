class UsersController < ApplicationController
  before_action :already_user, only: [:new, :create]
  before_action :authorized, only: [:edit, :update, :destroy]
  before_action :user_edit, only: [:edit, :update, :destroy]
  before_action :set_user, only: [:edit, :update, :destroy, :show]

  def index
    @users = User.last(5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, flash: { success: 'User successfully created!' }
    else
      render :new, flash: { error: 'Error!' }
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), flash: { success: 'Profile updated!' }
    else
      render :edit
    end
  end

  def show
    @questions = @user.questions.where.not(answer: nil)
    @question_new = Question.new
    @question_new.user_id = params[:id]
  end

  def destroy
    @user.destroy
    session[:user_id] = nil
    redirect_to root_url, flash: { success: 'User destroyed' }
  end

  private
  # Permitted params
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :username, :avatar_url, :bg_color)
  end
  # Authorization
  def authorized
    reject unless current_user.present?
  end
  # Can edit
  def user_edit
    reject_user unless current_user.present? && current_user.id == params[:id].to_i
  end
  # Set user
  def set_user
    @user = User.find_by(id: params[:id])
    reject_user unless @user
  end
  # User loggined
  def already_user
    reject_user if current_user.present?
  end
end
