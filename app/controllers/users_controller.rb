class UsersController < ApplicationController

  # before_action :authorize_user, except: [:index, :new, :create, :show]

  def index
    @users = User.all
  end

  def new
    p "Controller is: "
    p params[:controller]
    redirect_to root_url, alert: 'You are already logined!' if current_user.present?

    @user = User.new
  end

  def create
    redirect_to root_url, alert: 'You are already logined!' if current_user.present?

    @user = User.new(user_params)

    if @user.save
      # Redirecting with FLash Message
      redirect_to root_url, notice: 'User successfully created!'
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    # If user isnt logined
    reject_user unless @user == current_user

    if @user.update(params[:id])
      redirect_to user_path(@user), notice: 'Profile updated!'
    else
      render 'edit'
    end
  end

  def edit
    @user = User.find(params[:id])
    # If user isnt logined
    reject_user unless @user == current_user
  end

  def show
    @user = User.find(params[:id])
    @questions = @user.questions.order(created_at: :desc)

    # Making new question
    @question_new = Question.new
    @question_new.user_id = params[:id]
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :username, :avatar_url)
  end

  def signed_in?
    return false
  end
end
