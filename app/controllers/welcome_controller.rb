class WelcomeController < ApplicationController
  def index
  end

  def error404
    render file: '/public/404', status: 404, layout: false
  end
end
