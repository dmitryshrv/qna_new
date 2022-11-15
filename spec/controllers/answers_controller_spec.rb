require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) {create(:answer, question: question, user: user)}

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer to database' do
        expect { post :create, params: {question_id: question, answer: attributes_for(:answer), user: user} }.to change(Answer, :count).by(1)
      end

      it 'renders show view'do
      post :create, params: {question_id: question, answer: attributes_for(:answer)}
      expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save a answer' do
        expect { post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid)} }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end

  end
end
