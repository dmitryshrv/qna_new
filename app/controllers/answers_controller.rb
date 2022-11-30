class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    @answer = question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
    @new_answer = @question.answers.build
    @new_answer.links.build
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    if current_user == answer.user
      answer.destroy
    end
  end

  def best
    @question = answer.question

    if current_user == @question.user
      @question.mark_as_best(answer)
      @question.reward&.update(user: @answer.user)
    end
  end

  def delete_file
    if current_user == answer.user
      @file = ActiveStorage::Attachment.find(params[:file_id])
      @file.purge
    end
  end

  def destroy_link
    @link = Link.find(params[:link])

    if current_user == answer.user
      @link.destroy
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
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end
end

