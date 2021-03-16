Rails.application.routes.draw do
  root 'dashboard#index'
  get '/:lang/:period', to: 'dashboard#index'
  get '/pushes/:type/:lang/:moment', to: 'dashboard#pushes'
  get '/pushes/:type/all', to: 'dashboard#pushes'
  get '/pushes', to: 'dashboard#pushes'
end
