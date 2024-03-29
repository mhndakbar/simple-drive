Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :v1, :defaults => {:format => :json } do
    resources :auth do
      collection do
        post :register
        post :login
      end
    end

    resources :blobs
  end
end
