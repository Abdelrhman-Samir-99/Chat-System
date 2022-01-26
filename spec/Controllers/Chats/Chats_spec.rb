require 'rails_helper'

# bundle exec rspec spec/Controllers/Chats/Chats_spec.rb

=begin
	- I checked for referential integrity manually, I will learn how to do it using unit testing later.
	- Same for Chat_id, that it starts from 1 and no two chats have the same ID.
		- Didn't try when parallel happens, but I used locks. so hopefully I used it correctly.
	- I checked that whenever we delete/add a chat, that will decrement/increment the chats_count in the application.
=end

describe 'Chats API', type: :request do
	
	before do
		@first_app = FactoryBot.create(:application, name: "Ahmed")
		@second_app = FactoryBot.create(:application, name: "Testing")
	
		@first_chat = FactoryBot.create(:chat, Application_id: @first_app[:id], Chat_id: 1)
		@second_chat = FactoryBot.create(:chat, Application_id: @second_app[:id], Chat_id: 1)
		@third_chat = FactoryBot.create(:chat, Application_id: @second_app[:id], Chat_id: 2)
	end

	describe 'GET /application/:application_token/chat/show/:Chat_id' do
		it 'returns the messages_count of a specific chat' do
			get "/application/#{@first_app.Application_Token}/chat/show/#{@first_chat.Chat_id}"

			expect(JSON.parse(response.body).size).to eq(1)
			expect(response).to have_http_status(:success)
		end
	end

	describe 'GET /application/:application_token/chat/index' do
		it 'return messages_count for all chat in a specific application' do
			get "/application/#{@second_app.Application_Token}/chat/index"

			expect(JSON.parse(response.body).size).to eq(2)
			expect(response).to have_http_status(:success)
		end
	end

	describe 'PUT /application/:application_token/chat/create' do
		it 'Create a new chat for a specific application' do
			expect {
				put "/application/#{@second_app.Application_Token}/chat/create"
			}.to change {Chat.count}.from(3).to(4)
			
			expect(response).to have_http_status(:created)
		end
	end

	describe 'DELETE /application/:application_token/chat/delete/:Chat_id' do
		it 'Deletes a chat in specific application' do
			expect {
				delete "/application/#{@first_app.Application_Token}/chat/delete/#{@first_chat.Chat_id}"
			}.to change {Chat.count}.from(3).to(2)

			expect(response).to have_http_status(:no_content)
		end
	end
end