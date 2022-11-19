Rails.application.routes.draw do
  devise_for :users

  root "questions#index"

  resources :questions do
    resources :answers, shallow: true do
      member {post :best}
    end
  end

end
