class DashboardController < ApplicationController
  def index
    require "net/http"

    if params[:lang].nil?
      @lang = "all"
      @period = "today"
    else
      @lang = params[:lang]
      @period = params[:period]
    end

    url_prod = "https://apihosanna.contentor.io"
    url_test = "https://7f1ba8530416.ngrok.io"

    url = URI(url_prod + "/v1/get_dashboard_data/" + @lang + "/" + @period)
		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		
		request = Net::HTTP::Post.new(url)
		request["content-type"] = 'application/json'

		response = http.request(request)
    p request
		@users = JSON.parse(response.read_body)["users"]
    @intro_ok = JSON.parse(response.read_body)["intro_ok"]
    @monthly_active_purchases = JSON.parse(response.read_body)["monthly_active_purchases"]
    @yearly_active_purchases = JSON.parse(response.read_body)["yearly_active_purchases"]

  end
end
