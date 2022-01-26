require 'rails_helper'
# bundle exec rspec spec/Controllers/Applications/Applications_spec.rb

describe 'Applications API', type: :request do
	
	before do
		@first = FactoryBot.create(:application, name: "Ahmed")
		@second = FactoryBot.create(:application, name: "Testing")

	end

	describe 'GET /application/show/:application_token' do
		it 'returns a specific applications' do
			get "/application/show/#{@first.Application_Token}"

			expect(JSON.parse(response.body).size).to eq(1)
			expect(response).to have_http_status(:success)
			# should also check that they have the same token
		end
	end

	describe 'GET /application/index' do
		it 'return all application' do
			get '/application/index'

			expect(JSON.parse(response.body).size).to eq(Application.count)
			expect(response).to have_http_status(:success)
		end
	end

	describe 'PUT /application/create/:name' do
		it 'Create a new application' do
			expect {
				put '/application/create/:name'
			}.to change {Application.count}.from(2).to(3)

			expect(response).to have_http_status(:created)
		end
	end
	


	describe 'DELETE /application/delete/:application_token' do
		it 'Delete an application using its token' do
			expect {
				delete "/application/delete/#{@second.Application_Token}"
			}.to change {Application.count}.from(2).to(1)

			expect(response).to have_http_status(:no_content)
		end
	end
end