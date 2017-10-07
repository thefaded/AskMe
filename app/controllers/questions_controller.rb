class QuestionsController < ApplicationController
#  before_action
  before_action :set_question, only: [:show, :edit, :update, :destroy]
#  before_action :authorize_user, except: [:create]

  # Showing all questions without answers
  def index
    sql = "SELECT id, text, created_at FROM questions WHERE user_id == #{session[:user_id]} AND answer IS NULL"
    @questions = ActiveRecord::Base.connection.execute(sql)
  end

  # POST /questions
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
    if check_question
      render :edit
    else
      redirect_to root_url, notice: 'Permission denied'
    end
  end

  # Answering question
  def update

  end

  # DELETE /questions/1
  def destroy
    user = @question.user
    @question.destroy

    redirect_to user_path(user), notice: 'Question deleted'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # def authorize_user
    #   reject user unless @question.user == current_user
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:user_id, :text, :answer)
    end

    # Checking if current user can answer the question
    def check_question
      return true if current_user && current_user.questions.find_by(id: params[:id])
    end
end
