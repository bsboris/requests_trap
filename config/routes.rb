Rails.application.routes.draw do
  root 'main#index'
  match "/:trap", to: 'requests#create', via: :all
end
