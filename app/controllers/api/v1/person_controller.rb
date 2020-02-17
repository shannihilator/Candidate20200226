module Api
	module V1
		class PersonController < Api::BaseController

			def index
				render json: {test: "Hello World"}
			end
		end
  end
end
