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
      redirect_to user_path(@question.user), flash: { success: 'Question created!' }
    else
      redirect_to root_url, flash: { error: 'Error, while creating question' }
    end
  end
  
  def index
    # Showing all questions without answers
    @questions = Question.where(user_id: session[:user_id], answer: nil)
  end
  
  def update
    @question.answer = question_params[:answer]

    if @question.save
      redirect_to user_path(@question.user), flash: { success: 'Question successfully answered!' }
    else
      redirect_to edit_question_path(@question), flash: { error: 'Error while answering question' }
    end
  end
  
  def destroy
    @question.destroy
    redirect_to questions_path, flash: { success: 'Question destroyed!' }
  end
  # Destroy all questions
  def destroy_all
    if current_user.questions.destroy_all
      redirect_to questions_path, flash: { success: 'Questions destroyed!' }
    else
      redirect_to questions_path, flash: { error: 'Error while destroying questions' }
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
