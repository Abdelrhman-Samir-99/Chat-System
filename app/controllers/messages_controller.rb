class MessagesController < ApplicationController
	def create
		application = Application.find_by(Application_Token: params[:application_token])
    	
    	if application
    		chat = Chat.find_by(Application_id: application[:id], Chat_id: params[:Chat_id])
  		end
  		
  		if chat and Message.create(body: params[:body], Application_id: application[:id], Chat_id: chat[:id], message_id: chat[:messages_count] + 1) and chat.update(messages_count: chat[:messages_count] + 1)
			render json: Message.last, status: :ok
		else
			render json: {statuse: "Failed to create a new message!"}
		end
	end
	
	def index
		application = Application.find_by(Application_Token: params[:application_token])
    	
    	if application
    		chat = Chat.find_by(Application_id: application[:id], Chat_id: params[:Chat_id])
  		end

		if chat
			messages = Message.where(Application_id: application[:id], Chat_id: chat[:id])
		end

		if messages
			render json: messages, status: :ok
		else
			render json: {statuse: "No messages found!"}, status: :not_found
		end
	end

	def show
		application = Application.find_by(Application_Token: params[:application_token])
    	
    	if application
    		chat = Chat.find_by(Application_id: application[:id], Chat_id: params[:Chat_id])
  		end

		if chat
			message = Message.find_by(Application_id: application[:id], Chat_id: chat[:id], message_id: params[:message_id])
		end


		if message
			render json: message, status: :ok
		else
			render json: {statuse: "Message not found!"}
		end
	end

	def destroy
		application = Application.find_by(Application_Token: params[:application_token])
    	
    	if application
    		chat = Chat.find_by(Application_id: application[:id], Chat_id: params[:Chat_id])
  		end

		if chat
			message = Message.find_by(Application_id: application[:id], Chat_id: chat[:id], message_id: params[:message_id])
		end

		if message and message.destroy and chat.update(messages_count: chat[:messages_count] - 1)
			render json: {statuse: "Message has been deleted!"}, status: :ok
		else
			render json: {statuse: "Failed to delete the message!"}
		end
	end

	

	def update
		application = Application.find_by(Application_Token: params[:application_token])
    	
    	if application
    		chat = Chat.find_by(Application_id: application[:id], Chat_id: params[:Chat_id])
  		end

		if chat
			message = Message.find_by(Application_id: application[:id], Chat_id: chat[:id], message_id: params[:message_id])
		end
		
		if message and message.update(body: params[:body])
			render json: message, status: :ok
		else
			render json: {statuse: "Failed to update the message!"}
		end
	end

end
