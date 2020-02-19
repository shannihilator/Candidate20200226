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

			def characterCount
				characterHash = {}
				uri = URI('https://api.salesloft.com/v2/people.json')
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri)
        request["Authorization"] = "Bearer #{ENV['SALESLOFT_APPLICATION_SECRET']}"
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        response = http.request(request)
        response_body = JSON.parse(response.body)
        response_body["data"].each do |person|
        	retrieveCharacterCount(person["email_address"].downcase, characterHash)
      	end
      	characterHash = Hash[characterHash.sort_by{|k, v| v}.reverse]
        render json: {response: characterHash, response_code: 200}
			end

			# ***************** Private Methods ********************
	    private

	    def retrieveCharacterCount(email, characterHash)
	    	email.each_char{ |c|
  				if characterHash.has_key?(c)
  					characterHash[c] = characterHash[c] + 1
  				else
  					characterHash[c] = 1
  				end
				}
	    end # End makeRequest
		end # End Class PersonController
  end # End module V1
end # End module Api
