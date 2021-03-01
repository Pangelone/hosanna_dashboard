class DashboardController < ApplicationController
  def index
    require "net/http"

    lang = params[:lang]
    period = params[:period]

    if lang == "es"
      if period == "today"
        url = URI('https://daab2c4be2dd.ngrok.io/v1/get_dashboard_data/es/today')
      elsif period == "wtd"
        url = URI('https://daab2c4be2dd.ngrok.io/v1/get_dashboard_data/es/wtd')
      elsif period == "mtd"
        url = URI('https://daab2c4be2dd.ngrok.io/v1/get_dashboard_data/es/mtd')
      elsif period == "ytd"
        url = URI('https://daab2c4be2dd.ngrok.io/v1/get_dashboard_data/es/ytd')
      end
    elsif lang == "en"
      if period == "today"
        url = URI('https://daab2c4be2dd.ngrok.io/v1/get_dashboard_data/en/today')
      elsif period == "wtd"
        url = URI('https://daab2c4be2dd.ngrok.io/v1/get_dashboard_data/en/wtd')
      elsif period == "mtd"
        url = URI('https://daab2c4be2dd.ngrok.io/v1/get_dashboard_data/en/mtd')
      elsif period == "ytd"
        url = URI('https://daab2c4be2dd.ngrok.io/v1/get_dashboard_data/en/ytd')
      end
    elsif lang == "pt"
      if period == "today"
        url = URI('https://daab2c4be2dd.ngrok.io/v1/get_dashboard_data/pt/today')
      elsif period == "wtd"
        url = URI('https://daab2c4be2dd.ngrok.io/v1/get_dashboard_data/pt/wtd')
      elsif period == "mtd"
        url = URI('https://daab2c4be2dd.ngrok.io/v1/get_dashboard_data/pt/mtd')
      elsif period == "ytd"
        url = URI('https://daab2c4be2dd.ngrok.io/v1/get_dashboard_data/pt/ytd')
      end
    elsif lang == "all"
      if period == "today"
        url = URI('https://daab2c4be2dd.ngrok.io/v1/get_dashboard_data/all/today')
      elsif period == "wtd"
        url = URI('https://daab2c4be2dd.ngrok.io/v1/get_dashboard_data/all/wtd')
      elsif period == "mtd"
        url = URI('https://daab2c4be2dd.ngrok.io/v1/get_dashboard_data/all/mtd')
      elsif period == "ytd"
        url = URI('https://daab2c4be2dd.ngrok.io/v1/get_dashboard_data/all/ytd')
      end
    else
      url = URI('https://daab2c4be2dd.ngrok.io/v1/get_dashboard_data/all/today')
    end
    
		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		
		request = Net::HTTP::Post.new(url)
		request["content-type"] = 'application/json'

		response = http.request(request)

		p @users = JSON.parse(response.read_body)["data"]["users"]
    p @intro_ok = JSON.parse(response.read_body)["data"]["intro_ok"]
    p @monthly_active_purchases = JSON.parse(response.read_body)["data"]["monthly_active_purchases"]
    p @yearly_active_purchases = JSON.parse(response.read_body)["data"]["yearly_active_purchases"]

  end
end
