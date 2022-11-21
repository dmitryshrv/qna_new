class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    @answer = question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
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
    end
  end

  def delete_file
    if current_user == answer.user
      @file = ActiveStorage::Attachment.find(params[:file_id])
      @file.purge
    end
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    #@answer ||= Answer.with_attached_files.find(params[:id])
    @answer ||= Answer.find(params[:id])
  end

  helper_method :question

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end

