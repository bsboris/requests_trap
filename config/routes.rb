Rails.application.routes.draw do
  root 'main#index'
  match "/:trap", to: 'requests#create', via: :all
  get "/:trap/requests", to: 'requests#index'
  get "/:trap/requests/:id", to: 'requests#show', as: :request
end
