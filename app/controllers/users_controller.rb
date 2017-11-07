class UsersController < ApplicationController
  before_action :already_user, only: [:new, :create]
  before_action :authorized, only: [:edit, :update]
  before_action :user_edit, only: [:edit, :update]
  before_action :set_user, only: [:edit, :update, :show]

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
      redirect_to root_url, notice: 'User successfully created!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'Profile updated!'
    else
      render :edit
    end
  end

  def show
    @questions = @user.questions.where('answer <> "" AND answer IS NOT NULL').order(created_at: :desc)

    @question_new = Question.new
    @question_new.user_id = params[:id]
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
    @user = User.find(params[:id])
  end
  # User loggined
  def already_user
    reject_user if current_user.present?
  end
end
