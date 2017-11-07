class QuestionsController < ApplicationController
  before_action :authorize_user, except: [:create]
  before_action :question_edit, only: [:edit, :update, :destroy]
  before_action :set_question, only: [:edit, :update, :destroy]

  def create
    @question = Question.new
    @question.user_id = question_params[:user_id]
    @question.text = question_params[:text]

    if @question.save
      redirect_to user_path(@question.user)
    else
      redirect_to root_url
    end
  end
  # Showing all questions without answers
  def index
    @questions = Question.where(user_id: session[:user_id], answer: nil)
  end
  # Answering question
  def update
    @question.answer = question_params[:answer]
    if @question.save
      redirect_to user_path(@question.user), notice: 'Question successfully answered!'
    else
      redirect_to edit_question_path(@question)
    end
  end
  # Deleting question
  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Question deleted'
  end

  private
  # Permitted params
  def question_params
    params.require(:question).permit(:user_id, :text, :answer, :id)
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
