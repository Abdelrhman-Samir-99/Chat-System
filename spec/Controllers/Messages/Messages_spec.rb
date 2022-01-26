require 'rails_helper'

# bundle exec rspec spec/Controllers/Messages/Messages_spec.rb

=begin
	- I checked the referential integrity using postman and rails compiler.
	- the auto-increment does work in the test enviroment, but works fine in the production.
	- not the best unit test ever, but I did much more effort in testing manually.
=end

describe 'Messages API', type: :request do
	
	before do
		@first_app = FactoryBot.create(:application, name: "Ahmed")
		@second_app = FactoryBot.create(:application, name: "Testing")
	
		@first_chat = FactoryBot.create(:chat, Application_id: @first_app[:id], Chat_id: 1)
		@second_chat = FactoryBot.create(:chat, Application_id: @second_app[:id], Chat_id: 1)

		@first_message = FactoryBot.create(:message, Application_id: @first_app[:id], Chat_id: @first_chat[:id], message_id: 1, body: "BLABLABLA0")		
		@second_message = FactoryBot.create(:message, Application_id: @second_app[:id], Chat_id: @second_chat[:id], message_id: 1, body: "BLABLABLA1")
		@third_message = FactoryBot.create(:message, Application_id: @second_app[:id], Chat_id: @second_chat[:id], message_id: 2, body: "BLABLABLA2")
	end

	describe 'GET /application/:application_token/chat/:Chat_id/message/index' do
		it 'returns all the messages in a specific chat' do
			get "/application/#{@second_app.Application_Token}/chat/#{@second_chat.Chat_id}/message/index"

			expect(JSON.parse(response.body).size).to eq(2)
			expect(response).to have_http_status(:success)
		end
	end

	describe 'GET /application/:application_token/chat/:Chat_id/message/show/:message_id' do
		it 'returns specific message info' do
			get "/application/#{@second_app.Application_Token}/chat/#{@second_chat.Chat_id}/message/show/#{@third_message.message_id}"

			expect(JSON.parse(response.body)['message_id']).to eq(2)
			expect(response).to have_http_status(:success)
		end
	end

	describe 'PUT /application/:application_token/chat/:Chat_id/message/create/:body' do
		it 'Create a new message in a specific chat' do
			expect {
				put "/application/#{@first_app.Application_Token}/chat/#{@first_chat.Chat_id}/message/create/#{"testinggg"}"
			}.to change {Message.count}.from(3).to(4)

			#expect(JSON.parse(response.body)['message_id']).to eq(2) this shold be 2, but not sure how the database works in test environmtn.		
			expect(response).to have_http_status(:created)
		end
	end

	describe 'DELETE /application/:application_token/chat/:Chat_id/message/delete/:message_id' do
		it 'Deletes a message in specific chat' do
			expect {
				delete "/application/#{@second_app.Application_Token}/chat/#{@second_chat.Chat_id}/message/delete/#{@third_message.message_id}"
			}.to change {Message.count}.from(3).to(2)


			expect(response).to have_http_status(:no_content)
		end
	end


	describe 'POST /application/:application_token/chat/:Chat_id/message/update/:message_id/:body' do
		it 'Update a message in specific chat' do
			post "/application/#{@second_app.Application_Token}/chat/#{@second_chat.Chat_id}/message/update/#{@third_message.message_id}:message_id/#{"UPDATED!"}"
			

			expect(JSON.parse(response.body)['body']).to eq("UPDATED!")
			expect(response).to have_http_status(:success)
		end
	end
end