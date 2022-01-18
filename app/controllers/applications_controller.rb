class ApplicationsController < ApplicationController
	def create
    	# retrieving the last created application
    	if Application.create(name: params[:name], chats_count: 0)
    		render json: {application_Token: Application.last[:Application_Token]}, status: :found
    	else
    		render json: {statuse: "failed"}
    	end
  	end

  	
	def index
		render json: Application.all, status: :ok
	end

  	def show
   	 	application = Application.find_by(Application_Token: params[:application_token])
 		
 		if application
 			render json: application, status: :found
 		else
 			render json: {statuse: 'The application does not exist!'}, status: :not_found
 		end
   	 end

	def destroy
		application = Application.find_by(Application_Token: params[:application_token])
		if application and application.destroy
			# this will be rendered even if the application does not exist.       may need to be fixed.
			render json: {statuse: "application has been deleted!"}, status: :gone
		else
			render json: {statuse: "Failed to delete the application!"}, status: :not_found
		end
	end
end
