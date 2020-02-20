
# ---------------------------------------------------------------------------------------------------------------
# [TODO] (What I would finish if I was to keep working on this project)
# 1. Move private functions below to Model or Lib folder (person specific methods: model file, generic: lib dir)
# 2. Remove as much hardcoded values (ie: URL, strings, etc) as possible in the actual code flow
# 3. Add authentication and authorization
# 4. Add actual Logging
# 5. Write Respec Tests
# 6. Use Linting tool
# 7. Crosscheck organzational coding standards with documentation and correct if needed
# 8. Submit Merge Request
# 9. Code Review
# 10. Add NonFunctional Requirements to Client Application (loading bar, additional css)

# Notes: Didnt use DB because it was no in requirements
# 			 Also passed on some Non-Functional Requirements as listed above
# ---------------------------------------------------------------------------------------------------------------


# Api Module
module Api
	# V1 Module
	module V1
		require "net/http"

		# PersonController Class
		class PersonController < Api::BaseController

			# Initial Test Method make routing was working
			def index
				render json: {test: "Hello World"}
			end # End index

			# retrieve people from SalesLoft API
			def getPeople
				begin
					# Call getPeopleData method to retrieve data from SalesLoft API
					# [TODO] LOG [DEBUG MESSAGE]
					response_body = getPeopleData
					
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

					# Call getPeopleData method to retrieve data from SalesLoft API
					response_body = getPeopleData

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
					# Call getPeopleData method to retrieve data from SalesLoft API
					response_body = getPeopleData
					
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

	    # retrieves all the people_data from sales_loft api
	    def getPeopleData
	    	# initialize variables
	    	people_data_arr = []
	    	current_page = 0
	    	total_pages = nil

	    	# setup data after first request 
	    	first_response_data = makeApiRequest(current_page)
	    	people_data_arr.concat(first_response_data["data"])
	    	total_pages = first_response_data["metadata"]["paging"]["total_pages"]
	    	current_page = first_response_data["metadata"]["paging"]["current_page"]
	    	
	    	# call api until all pages are retrieved
	    	while (current_page <= total_pages)
	    		current_page = current_page + 1
 	    		response_data = makeApiRequest(current_page)
 	    		people_data_arr.concat(response_data["data"])
	    	end

	    	# add array of all people data to last retrieved response_data
	    	response_data["data"] = people_data_arr
	    	return response_data
	    end

	    # makes network call to sales_loft api with page_number
	    def makeApiRequest(page_number)
	    	uri = URI("https://api.salesloft.com/v2/people.json?include_paging_counts=true&per_page=100&page=#{page_number}")
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
