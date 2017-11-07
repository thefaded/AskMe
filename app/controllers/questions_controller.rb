class QuestionsController < ApplicationController
  before_action :authorize_user, except: [:create]
  before_action :check_question, only: [:edit, :update]
  before_action :set_question, only: [:edit, :update, :destroy]
  # Showing all questions without answers
  def index
    @questions = Question.where(user_id: session[:user_id], answer: nil)
  end

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

  # Form for answering question
  def edit
  end

  # Answering question
  def update
    @question.answer = question_update[:answer]
    if @question.save
      redirect_to user_path(@question.user), notice: 'Question successfully answered!'
    else
      redirect_to edit_question_path(@question)
    end
  end

  # Deleting question
  def destroy
    delete_question
    user = @question.user
    @question.destroy
    redirect_to user_path(user), notice: 'Question deleted'
  end

  private
    # Finding question by id
    def set_question
      @question = Question.find(params[:id])
    end
    # Checking question for delete
    def delete_question
      reject_user unless current_user.present? && current_user.id == set_question.user_id
    end
    # Checking permission for editing
    def check_question
      reject_user unless current_user.present? && current_user.id == set_question.user_id && (set_question.answer == nil || set_question.answer == "")
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:user_id, :text, :answer)
    end
    # Permitted params for update
    def question_update
      params.require(:question).permit(:answer)
    end
    # Checking authorize user
    def authorize_user
      reject_user unless current_user.present?
    end
end
