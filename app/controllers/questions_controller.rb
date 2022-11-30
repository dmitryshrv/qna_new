class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @questions = Question.all
  end

  def show
    @best_answer = question.best_answer
		@other_answers = question.answers.where.not(id: @question.best_answer_id)

    @answer = question.answers.build
    @answer.links.build
  end

  def new
    question.links.build
    question.build_reward
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def update
    question.update(question_params)
  end

  def destroy
    if current_user == question.user
      question.destroy
      redirect_to questions_path, notice:"Question is successfully deleted"
    end
  end

  def delete_file
    if current_user == question.user
      @file = ActiveStorage::Attachment.find(params[:file_id])
      @file.purge
    end
  end

  def destroy_link
    @link = Link.find(params[:link])

    if current_user == question.user
      @link.destroy
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(
      :title,
      :body,
      files: [],
      links_attributes: [:id, :name, :url, :_destroy],
      reward_attributes: [:title, :image]
    )
  end
end
