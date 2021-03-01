Rails.application.routes.draw do
  root 'dashboard#index'
  get '/:lang/:period', to: 'dashboard#index'
end
