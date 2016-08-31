Rails.application.routes.draw do
  resources :users do
    collection do
      get :sign_in
      post :sign_in
      get :me
    end
  end

  resources :seeds do
    collection do
      post :create_payload
    end
  end
end
