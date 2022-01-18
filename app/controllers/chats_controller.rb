class ChatsController < ApplicationController
	def create
		application = Application.find_by(Application_Token: params[:application_token])
    
		if application and Chat.create(Application_id: application[:id], messages_count: 0, Chat_id: application[:chats_count] + 1) and application.update(chats_count: application[:chats_count] + 1)
        	render json: {chat_id: Chat.last[:Chat_id]}, status: :ok
      	else
      		render json: {statuse: "failed"}
        end
  	end
	
	def index
		application = Application.find_by(Application_Token: params[:application_token])
    	
    	if application
    		chats = Chat.where(Application_id: application[:id])
		end
		
		if chats
			render json: Chat.all
		else
			render json: {statuse: "No chats found!"}
		end
	end


  	def show
  		application = Application.find_by(Application_Token: params[:application_token])
    	
    	if application
    		chat = Chat.find_by(Application_id: application[:id], Chat_id: params[:Chat_id])
  		end

  		if chat
  			render json: chat, status: :ok
  		else
  			render json: {statuse: "This chat does not exist!"}
   		end
   	end



	def destroy
		
		application = Application.find_by(Application_Token: params[:application_token])
    	
    	if application
    		chat = Chat.find_by(Application_id: application[:id], Chat_id: params[:Chat_id])
  		end
  		
  		# this condition should be a transaction.
		if chat and Chat.destroy_by(Application_id: application[:id], Chat_id: chat[:Chat_id]) and application.update(chats_count: application[:chats_count] - 1)
			render json: {statuse: "The chat has been deleted!"}, status: :ok
		else
			render json: {statuse: "Failed to delete the chat"}, status: :not_found
		end
	end

end
