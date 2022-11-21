require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) {create_list(:question, 3)}

    before {get :index}

    it 'populates array of all qustions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before {get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'renders show view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before {get :edit, params: { id: question } }

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question to database' do
        expect { post :create, params: {question: attributes_for(:question)} }.to change(Question, :count).by(1)
      end

      it 'renders show view'do
      post :create, params: {question: attributes_for(:question)}
      expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save a question' do
        expect { post :create, params: {question: attributes_for(:question, :invalid)} }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: {question: attributes_for(:question, :invalid)}
        expect(response).to render_template :new
      end
    end

  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: {title: "new title", body: "new body"}, format: :js }
        question.reload
        expect(question.title).to eq "new title"
        expect(question.body).to eq "new body"
      end

      it 'redirects to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js  }
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      let!(:question) { create(:question, title: 'MyString', body: 'MyText') }
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

      it 'does not change question' do
        question.reload
        expect(question.title).to eq "MyString"
        expect(question.body).to eq "MyText"
      end

      it 're-renders edit view' do
        expect(response).to render_template :update
      end
    end
  end

  describe "DELETE #destroy" do
    before { login(user) }

    let!(:question) { create(:question, user: user) }

    it 'deletes the question' do
      expect { delete :destroy, params: {id: question} }.to change(Question, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: {id: question}
      expect(response).to redirect_to questions_path
    end
  end

  describe 'DELETE #delete_file' do

    before do
      question.files.attach(
        io: File.open(Rails.root.join('spec', 'rails_helper.rb')),
        filename: 'rails_helper.rb'
      )
      login(user)
    end

    let!(:question) { create(:question, user: user) }

    it 'delete question file' do
      expect do
        delete :delete_file, params: { id: question.id, file_id: question.files.first.id}, format: :js
      end.to change(question.files, :count).by(-1)
    end

    it 'render delete_file view' do
      delete :delete_file, params: { id: question, file_id: question.files.first.id }, format: :js
      expect(response).to render_template :delete_file
    end
  end

end
