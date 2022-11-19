require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) {create(:answer, question: question, user: user)}
  let!(:another_answer) { create(:answer, question:, user: another_user) }


  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer to database' do
        expect { post :create, params: {
                                        question_id: question,
                                        answer: attributes_for(:answer),
                                        user: user,
                                        format: :js} }.to change(Answer, :count).by(1)
      end

      it 'renders create template'do
      post :create, params: {question_id: question, answer: attributes_for(:answer), format: :js}
      expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save a answer' do
        expect { post :create, params: {
                                          question_id: question,
                                          answer: attributes_for(:answer, :invalid)
                                        }, format: :js }.to_not change(Answer, :count)
      end

      it 're-renders create template' do
        post :create, params: {
                                question_id: question,
                                answer: attributes_for(:answer, :invalid),
                                format: :js
                              }
        expect(response).to render_template :create
      end
    end

  end

  describe 'PATCH #update' do
    let!(:answer) {create(:answer, question: question, user: user)}

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: {
                                id: answer,
                                answer: {body: "new body"}
                              }, format: :js

        answer.reload
        expect(answer.body).to eq "new body"
      end

      it 'renders update view' do
        patch :update, params: {
                                id: answer,
                                answer: {body: "new body"}
                              }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it "doesn't change answer attributes" do
        expect do
          patch :update, params: {id: answer, answer: attributes_for(:answer, :invalid)}, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: {
                                id: answer,
                                answer: attributes_for(:answer, :invalid)
                              }, format: :js

        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    context "User is answer's author" do
      before { login(user) }

      it 'Deletes answer' do
        expect do
          delete :destroy, params: { id: answer, question_id: question, format: :js }
        end.to change(Answer, :count).by(-1)
      end

      it 'Renders destroy' do
        delete :destroy, params: { id: answer, question_id: question, format: :js }

        expect(response).to render_template :destroy
      end
    end

    context "User is not answer's author" do
      before { login(user) }

      it 'does not delete an answer' do
        expect do
          delete :destroy, params: { id: another_answer, question_id: question, format: :js }
        end.not_to change(Answer, :count)
      end
    end
  end

  describe "POST #best" do
    context "when user is question's author" do
      before do
        login(user)
        post :best, params: {id: answer, format: :js}
      end

      it "makes an answer the bes" do
        question.reload

        expect(question.best_answer).to eq answer
      end

      it "renders best template" do
        expect(response).to render_template :best
      end
    end
  end

end
