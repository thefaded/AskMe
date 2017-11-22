class QuestionsController < ApplicationController
  before_action :authorize_user, except: [:create]
  before_action :question_edit, only: [:edit, :update, :destroy]
  before_action :set_question, only: [:edit, :update, :destroy]

  def create
    @question = Question.new
    @question.user_id = question_params[:user_id]
    @question.text = question_params[:text]
    @question.author_id = current_user.id if current_user.present?

    if @question.save
      redirect_to user_path(@question.user), notice: 'Question created!'
    else
      redirect_to root_url, notice: 'Error, while creating question'
    end
  end
  
  def index
    # Showing all questions without answers
    @questions = Question.where(user_id: session[:user_id], answer: nil)
  end
  
  def update
    @question.answer = question_params[:answer]

    if @question.save
      redirect_to user_path(@question.user), notice: 'Question successfully answered!'
    else
      redirect_to edit_question_path(@question), notice: 'Error, please retry'
    end
  end
  
  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Question deleted'
  end

  def destroy_all
    if current_user.questions.destroy_all
	    redirect_to questions_path, notice: 'Questions deleted'
    else
			redirect_to questions_path, notice: 'Error!'
    end
  end

  private
  # Permitted params
  def question_params
    params.require(:question).permit(:author, :user_id, :text, :answer, :id)
  end
  # Setting up question
  def set_question
    @question = Question.find(params[:id])
  end
  # Edit question (update, delete), checking authorization
  def question_edit
    reject_user if current_user.questions.where(id: params[:id]).empty?	
  end
  # Authorizing user
  def authorize_user
    reject_user unless current_user.present?
  end
end
