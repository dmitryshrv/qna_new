class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    @answer = question.answers.build(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to question_path(question), notice: 'Your answer was successfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user == answer.user
      @question = answer.question
      answer.destroy
      redirect_to @question, notice: 'Your Answer successfully deleted!'
    end
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= Answer.find(params[:id])
  end

  helper_method :question

  def answer_params
    params.require(:answer).permit(:body)
  end
end

