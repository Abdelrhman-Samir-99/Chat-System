class MessagesController < ApplicationController
	def create
		message = Message.add_message(params[:application_token], params[:Chat_id], params[:body])
		render json: {message_id: message[:message_id]}, status: :created
	end
	
	def index
		messages = Message.find_messages_by_chat_id_and_token(params[:Chat_id], params[:application_token])
		render json: messages, status: :ok
	end

	def show
		message = Message.find_message_by_chat_id_and_token_and_message_id(params[:Chat_id], params[:application_token], params[:message_id])
		render json: message, status: :ok
	end

	def destroy
		Message.destroy_message_by_chat_id_and_token_and_message_id(params[:Chat_id], params[:application_token], params[:message_id])
		render json: {statuse: "Message has been deleted!"}, status: :no_content
	end

	def update	
		message = Message.update_message_by_chat_id_and_token_and_message_id(params[:Chat_id], params[:application_token], params[:message_id], params[:body])
		render json: message, status: :ok
	end

end
