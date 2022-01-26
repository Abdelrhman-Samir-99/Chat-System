class ApplicationsController < ApplicationController
	def create
    	application = Application.add_application(params[:name])
    	render json: {application_Token: application[:Application_Token]}, status: :created
    end

  	
	# try to render only Application_token
	def index
		render json: Application.all, status: :ok
	end

  	def show
  	# there is a problem with the cahts_count cache... always off by one.
  	#	if Application.exists_in_chats_cache(params[:application_token]) == 0
  			application = Application.find_application_by_token(params[:application_token])
 			render json: {chats_count: application[:chats_count]}, status: :found
 	#	else
 	#		chats_count = $chats_count_cache.get(params[:application_token])
 	#		render json: {chats_count: chats_count}, status: :ok
 	#	end
   	end

	def destroy
		Application.destroy_application_by_token(params[:application_token])
		render json: {status: "application has been deleted!"}, status: :no_content
	end
end