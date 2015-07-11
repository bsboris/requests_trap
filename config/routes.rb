Rails.application.routes.draw do
  root 'main#index'
  match "/:trap", to: 'requests#create', via: :all, as: :trap
  get "/:trap/requests", to: 'requests#index', as: :requests
  get "/:trap/requests/events", to: 'requests#events'
  get "/:trap/requests/:id", to: 'requests#show', as: :request
end
