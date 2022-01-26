class ChatsController < ApplicationController
	def create
		chat = Chat.add_chat(params[:application_token])
	    render json: {chat_id: chat[:Chat_id]}, status: :created
   	end
	
	def index
		chats = Chat.find_chats_by_token(params[:application_token])
		render json: chats, status: :ok
	end


  	def show
  		if Chat.exists_in_messages_cache(params[:application_token], params[:Chat_id]) == 0
  			chat = Chat.find_chat_by_id_and_token(params[:Chat_id], params[:application_token])	
  			render json: {messages_count: chat[:messages_count]}, status: :ok
  		else
  			messages_count = Chat.fetch_from_messages_cache(params[:application_token], params[:Chat_id])
  			render json: {messages_count: messages_count}, status: :ok
  		end
   	end


	def destroy		
		Chat.destroy_chat_by_id_and_token(params[:Chat_id], params[:application_token])
		render json: {statuse: "The chat has been deleted!"}, status: :no_content
	end
end
