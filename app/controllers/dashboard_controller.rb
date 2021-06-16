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

    data = JSON.parse(response.read_body)

		@users = data["users"]
    @intro_ok = data["intro_ok"]
    @Intro_ok_porcentaje = (@intro_ok.to_f / @users.to_f * 100).round(2)
    @monthly_active_purchases = data["monthly_active_purchases"]
    @yearly_active_purchases = data["yearly_active_purchases"]

  end

  def contentor_pushes(app_id,type,period = 1)
    from = Date.today - period.to_i.day
    url = URI("http://api.contentor.io/3.11/pushes/#{type}")
    p url
    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url)
    request["content-type"] = 'application/json'
    request["Authorization"] = 'Bearer 352a38e84a523fed8d34a6f76235d826'
    request.body = "{\n\t\"app_id\": #{app_id},\n\t\"from\": \"#{from.to_s}\",\n\t\"to\": \"#{Date.today.to_s}\"\n}"
    response = http.request(request)
    unless JSON.parse(response.read_body)["pushes"].nil? 
      JSON.parse(response.read_body)["pushes"]
    else 
      []
    end
  end

  def pushes
    require "net/http"

    @lang = params[:lang]
    @type = params[:type]
    @moment = params[:moment]
    @interval = params[:interval]

    if params[:type] == "all" && params[:lang] == "all" && params[:moment] == "all"
      @pushes = [
        contentor_pushes(144,"on_demand",@interval),
        contentor_pushes(149,"on_demand",@interval),
        contentor_pushes(150,"on_demand",@interval),
        contentor_pushes(151,"on_demand",@interval),
        contentor_pushes(152,"on_demand",@interval),
        contentor_pushes(153,"on_demand",@interval),
        contentor_pushes(144,"subscription",@interval),
        contentor_pushes(149,"subscription",@interval),
        contentor_pushes(150,"subscription",@interval),
        contentor_pushes(151,"subscription",@interval),
        contentor_pushes(152,"subscription",@interval),
        contentor_pushes(153,"subscription",@interval)
      ]
    elsif params[:type] == "all" && params[:lang] == "all" && params[:moment] != "all"
      @pushes = [
        contentor_pushes(CONTENTOR_HOSANNA_APP_ID["es".to_sym][@moment.to_sym],"subscription",@interval),
        contentor_pushes(CONTENTOR_HOSANNA_APP_ID["en".to_sym][@moment.to_sym],"subscription",@interval),
        contentor_pushes(CONTENTOR_HOSANNA_APP_ID["pt".to_sym][@moment.to_sym],"subscription",@interval),
        contentor_pushes(CONTENTOR_HOSANNA_APP_ID["es".to_sym][@moment.to_sym],"on_demand",@interval),
        contentor_pushes(CONTENTOR_HOSANNA_APP_ID["en".to_sym][@moment.to_sym],"on_demand",@interval),
        contentor_pushes(CONTENTOR_HOSANNA_APP_ID["pt".to_sym][@moment.to_sym],"on_demand",@interval),
      ]    
    elsif params[:type] == "all" && params[:lang] != "all" && params[:moment] == "all"
      @pushes = [
        contentor_pushes(CONTENTOR_HOSANNA_APP_ID[@lang.to_sym]["day".to_sym],"subscription",@interval),
        contentor_pushes(CONTENTOR_HOSANNA_APP_ID[@lang.to_sym]["night".to_sym],"subscription",@interval),
        contentor_pushes(CONTENTOR_HOSANNA_APP_ID[@lang.to_sym]["day".to_sym],"on_demand",@interval),
        contentor_pushes(CONTENTOR_HOSANNA_APP_ID[@lang.to_sym]["night".to_sym],"on_demand",@interval),
      ]   
    elsif params[:type] == "all" && params[:lang] != "all" && params[:moment] != "all"
      @pushes = [
        contentor_pushes(CONTENTOR_HOSANNA_APP_ID[@lang.to_sym][@moment.to_sym],"subscription",@interval),
        contentor_pushes(CONTENTOR_HOSANNA_APP_ID[@lang.to_sym][@moment.to_sym],"on_demand",@interval),
      ]   
    elsif params[:type] != "all" && params[:lang] == "all" && params[:moment] == "all"
      @pushes = [
        contentor_pushes(144,@type,@interval),
        contentor_pushes(149,@type,@interval),
        contentor_pushes(150,@type,@interval),
        contentor_pushes(151,@type,@interval),
        contentor_pushes(152,@type,@interval),
        contentor_pushes(153,@type,@interval),
        contentor_pushes(144,@type,@interval),
        contentor_pushes(149,@type,@interval),
        contentor_pushes(150,@type,@interval),
        contentor_pushes(151,@type,@interval),
        contentor_pushes(152,@type,@interval),
        contentor_pushes(153,@type,@interval)
      ]
    elsif params[:type] != "all" && params[:lang] == "all" && params[:moment] != "all"
      @pushes = [
        contentor_pushes(CONTENTOR_HOSANNA_APP_ID["es".to_sym][@moment.to_sym],@type,@interval),
        contentor_pushes(CONTENTOR_HOSANNA_APP_ID["en".to_sym][@moment.to_sym],@type,@interval),
        contentor_pushes(CONTENTOR_HOSANNA_APP_ID["pt".to_sym][@moment.to_sym],@type,@interval),
      ]    
    elsif params[:type] != "all" && params[:lang] != "all" && params[:moment] == "all"
      @pushes = [
        contentor_pushes(CONTENTOR_HOSANNA_APP_ID[@lang.to_sym]["day".to_sym],@type,@interval),
        contentor_pushes(CONTENTOR_HOSANNA_APP_ID[@lang.to_sym]["night".to_sym],@type,@interval),
      ]  
    elsif params[:type] != "all" && params[:lang] != "all" && params[:moment] != "all"
      @pushes = [
        contentor_pushes(CONTENTOR_HOSANNA_APP_ID[@lang.to_sym][@moment.to_sym],@type,@interval),
      ]  
    end

    @affected = []
    @delivered  = []
    @clicked = []
    @pushes.each do |pushess|
      pushess.each do |push|
        @affected << [
          push["created_at"].to_date.to_s,
          push["affected_users"].to_f,
        ]
        @delivered << [
          push["created_at"].to_date.to_s,
          push["delivered"].to_f,
        ]
        @clicked << [
          push["created_at"].to_date.to_s,
          push["clicks"].to_f,
        ]
      end
    end
  end

    def tools
      url_prod = "https://apihosanna.contentor.io"
      url_test = "https://06e7b4d07a67.ngrok.io"
      slug = params[:slug]

      begin
        if slug.nil?  || slug == ""
          @msj = "Debe completar el slug"
        else            
          url = URI(url_prod + "/v1/remove_premium/" + slug)
          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = true
          #http.verify_mode = OpenSSL::SSL::VERIFY_NONE          
          request = Net::HTTP::Post.new(url)
          request["content-type"] = 'application/json'
          response = http.request(request)
          data = JSON.parse(response.read_body)
          @msj = data["msj"]
        end
      rescue 
        @msj = "Error de formato"
      end
    end

end
