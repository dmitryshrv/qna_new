Rails.application.routes.draw do
  devise_for :users

  root "questions#index"

  resources :rewards, only: %i[index]

  resources :questions do
    member do
      delete :delete_file
      delete :destroy_link
    end

    resources :answers, shallow: true do
      member do
        post :best
        delete :delete_file
        delete :destroy_link
      end
    end
  end

end
