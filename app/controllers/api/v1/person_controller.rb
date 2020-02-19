module Api
	module V1
		require "net/http"

		class PersonController < Api::BaseController

			def index
				render json: {test: "Hello World"}
			end

			def retrievePeople
				uri = URI('https://api.salesloft.com/v2/people.json')
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri)
        request["Authorization"] = "Bearer #{ENV['SALESLOFT_APPLICATION_SECRET']}"
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        response = http.request(request)
        response_body = JSON.parse(response.body)
        render json: {response: response_body, response_code: response.code}
			end
		end
  end
end
