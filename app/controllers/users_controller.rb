class UsersController < ApplicationController
  before_action :authorized?, only: [:update, :edit, :destroy]
  before_action :logined?, only: [:new, :create]

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

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'Profile updated!'
    else
      render :edit
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
    @questions = @user.questions.where('answer <> "" AND answer IS NOT NULL').order(created_at: :desc)

    @question_new = Question.new
    @question_new.user_id = params[:id]
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :username, :avatar_url, :bg_color)
  end

  def authorized?
    reject_user unless current_user.present? && current_user.id == params[:id].to_i
  end

  def logined?
    reject_user if current_user.present?
  end
end
