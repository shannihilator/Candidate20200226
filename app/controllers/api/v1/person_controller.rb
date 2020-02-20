module Api
	module V1
		require "net/http"

		class PersonController < Api::BaseController

			# Initial Test Method make routing was working
			def index
				render json: {test: "Hello World"}
			end # End index

			# retrieve people from SalesLoft API
			def getPeople
				begin
					# Call makeApiRequest method to retrieve data from SalesLoft API
					# [TODO] LOG [DEBUG MESSAGE]
					response_body = makeApiRequest
					
					# Return Response
	        render json: {
	        	response_data: response_body,
	        	operation: "get_people_data",
	        	status: "success",
	        	timestamp:Time.now, 
	        	uuid: SecureRandom.uuid, 
	        	response_code: 200,
	        	message: "Data Retrieved"
	        }
      	rescue StandardError => e
      		# [TODO] LOG [ERROR MESSAGE]
      		render json: {
	        	response_data: e.message,
	        	operation: "people_data",
	        	status: "error",
	        	timestamp:Time.now, 
	        	uuid: SecureRandom.uuid, 
	        	response_code: 500,
	        	message: "Error Occured"
	        } 
      	end # End rescue block
			end # End retrievePeople

			# retrieve character_count from SalesLoft people emails
			def getCharacterCount
				begin
					# [TODO] LOG [DEBUG MESSAGE]				
					# intialize variables
					character_hash = {}
					character_arr = []

					# Call makeApiRequest method to retrieve data from SalesLoft API
					response_body = makeApiRequest

					# Iterate over each person to pass email_address to retrieveCharacterCount method 
	        response_body["data"].each do |person|
	        	retrieveCharacterCount(person["email_address"].downcase, character_hash)
	      	end
	      	
	      	# Setup character_hash in descending order 
	      	character_hash = Hash[character_hash.sort_by{|k, v| v}.reverse]

	      	# push each element of character_hash onto an arr
	      	character_hash.each{|k,v|  character_arr.push({letter: k, count: v})}

	      	# Return Response
	        render json: {
	        	response_data: character_arr,
	        	operation: "get_character_count_data", 
	        	timestamp:Time.now,
	        	status: "success",  
	        	response_code: 200,
	        	uuid: SecureRandom.uuid,
	        	message: "Data Retrieved"
	        }
      	rescue StandardError => e
      		# LOG [ERROR MESSAGE]
      	  render json: {
	        	response_data: e.message,
	        	operation: "get_character_count_data",
	        	status: "error",
	        	timestamp:Time.now, 
	        	uuid: SecureRandom.uuid, 
	        	response_code: 500,
	        	message: "Error Occured"
	        }
      	end # End rescue block
			end # End retrieveCharacterCount

			# retrieve possible duplicates from SalesLoft people emails
			def getDuplicates
				begin
					# [TODO] LOG [DEBUG MESSAGE]
					# Call makeApiRequest method to retrieve data from SalesLoft API
					response_body = makeApiRequest
					
					# Extract all emails without whitespace remove everything after @ and downcase
	        response_body["data"].map!{|k| k["email_address"].downcase.gsub(/[[:space:]]/, '')}

	        # Break email up into username and domain
	        response_body["data"].map! {|email|
	        	symbol_index = email.index('@')
	        	email = {
	        			email_address: email,
	        			username: username = email[0..symbol_index-1],
	        			domain: email[symbol_index..email.length]
	        		}
	        }

	        # Call checkDupe Method
	        return_hash = checkDupe(response_body["data"])

	        # Return Response
	        render json: {
	        	response_data: return_hash, 
	        	timestamp:Time.now,
	        	operation: "get_duplicate_data", 
	        	status: "success", 
	        	uuid: SecureRandom.uuid,
	        	response_code: 200,
	        	message: "Data Retrieved"
	        }
      	rescue StandardError => e
      		# [TODO] LOG [ERROR MESSAGE]
	      	render json: {
		        	response_data: e.message,
		        	status: "error",
		        	operation: "get_duplicate_data", 
		        	timestamp:Time.now, 
		        	uuid: SecureRandom.uuid, 
		        	response_code: 500,
		        	message: "Error Occured"
		        }

      	end # End rescue block
			end # End retrieveDuplicates

			# ***************** Private Methods ********************
	    private

	    # private method that retrieves character count for given email_address
	    def retrieveCharacterCount(email, character_hash)
	    	email.each_char{ |c|
  				if character_hash.has_key?(c)
  					character_hash[c] = character_hash[c] + 1
  				else
  					character_hash[c] = 1
  				end
				}
	    end # End retrieveCharacterCount

	    # private method that checks duplicates in email_arr
	    def checkDupe(email_arr)
	    	dupeArr = []
	    	copy_arr = Array.new(email_arr)
	    	email_arr.each do |selected_obj|
	    		copy_arr.each do |copied_obj|  
	    		  
	    		  # make sure usernames are not compared to equals ones              
	    			if selected_obj[:username] != copied_obj[:username]
	    				
	    				# check if selected username is substring of copied_username
	    					if selected_obj[:username].include? copied_obj[:username]
	    						 
	    						 # check if selected_username length is in range of copied_username
	    							length_range = Range.new(copied_obj[:username].length,copied_obj[:username].length+2)
	    							if length_range.cover? selected_obj[:username].length
	    								
	    								# push original email & dupe email unto the dupeArr
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
