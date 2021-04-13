Rails.application.routes.draw do
  root 'dashboard#index'
  get '/pushes/:type/:lang/:moment/(:interval)', to: 'dashboard#pushes'
  get '/pushes/:type/all/(:interval)', to: 'dashboard#pushes'
  get '/pushes/(:interval)', to: 'dashboard#pushes'
  get '/:lang/:period', to: 'dashboard#index'
end
