module Api
	module V1
		require "net/http"

		class PersonController < Api::BaseController

			def index
				render json: {test: "Hello World"}
			end

			def retrievePeople
				response_body = makeApiRequest
        render json: {response: response_body, response_code: 200}
			end

			def characterCount
				character_hash = {}
				character_arr = []
				response_body = makeApiRequest
        response_body["data"].each do |person|
        	retrieveCharacterCount(person["email_address"].downcase, character_hash)
      	end
      	character_hash = Hash[character_hash.sort_by{|k, v| v}.reverse]
      	character_hash.each{|k,v|  character_arr.push({letter: k, count: v})}
        render json: {response: character_arr, response_code: 200}
			end

			def retrieveDuplicates
				response_body = makeApiRequest
				# Extract all emails without whitespace remove everything after @ and downcase
        response_body["data"].map!{|k| k["email_address"].downcase.gsub(/[[:space:]]/, '')}
        response_body["data"].map! {|email|
        	symbol_index = email.index('@')
        	#email.slice!(symbol_index-1..email.length)
        	email = {
        			email_address: email,
        			username: username = email[0..symbol_index-1],
        			domain: email[symbol_index..email.length]
        		}
        }
        return_hash = checkDupe(response_body["data"])

        render json: {response: return_hash, response_code: 200}
			end

			# ***************** Private Methods ********************
	    private

	    def retrieveCharacterCount(email, character_hash)
	    	email.each_char{ |c|
  				if character_hash.has_key?(c)
  					character_hash[c] = character_hash[c] + 1
  				else
  					character_hash[c] = 1
  				end
				}
	    end # End retrieveCharacterCount

	    def checkDupe(email_arr)
	    	dupeArr = []
	    	copy_arr = Array.new(email_arr)
	    	email_arr.each do |selected_obj|
	    		copy_arr.each do |copied_obj|                
	    			if selected_obj[:username] != copied_obj[:username]
	    					if selected_obj[:username].include? copied_obj[:username]
	    							length_range = Range.new(copied_obj[:username].length,copied_obj[:username].length+2)
	    							if length_range.cover? selected_obj[:username].length
	    									dupeArr.push(
	    										{
	    											original_email: selected_obj, 
	    											duplicate_email: copied_obj}
	    										)
	    							end # End if
	    					end # End if
	    			end # End if
	    		end # End do
	    	end # End do
	    	return dupeArr

	    end # End checkDupe

	    def makeApiRequest
	    	uri = URI('https://api.salesloft.com/v2/people.json')
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri)
        request["Authorization"] = "Bearer #{ENV['SALESLOFT_APPLICATION_SECRET']}"
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        response = http.request(request)
        response_body = JSON.parse(response.body)
        return response_body
	    end # End makeApiRequest

		end # End Class PersonController
  end # End module V1
end # End module Api
