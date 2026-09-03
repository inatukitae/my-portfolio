Rails.application.routes.draw do
  devise_for :users
  root "top#index"

  resources :posts do
    resource :reflection, only: [ :new, :create, :edit, :update ]
  end

  # 深掘り一覧と、ステータス切り替え用のルート
  resources :reflections, only: [ :index ] do
    member do
      patch :toggle_hidden
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
