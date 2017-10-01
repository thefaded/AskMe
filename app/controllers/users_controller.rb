class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
  end

  def edit
  end

  def show
    @user = User.new(name: 'Daniil', email: 'a@a.ru', username: 'poddubstep')
    @questions = [Question.new(text: 'How are you?', created_at: Date.parse('01.10.2017')),
      Question.new(text: 'What is ur hobby??', created_at: Date.parse('01.10.2017'))]
    @questions[0].answer = "I'm fine"
    @questions[1].answer = "Coding"

    @new_question = Question.new
  end
end
