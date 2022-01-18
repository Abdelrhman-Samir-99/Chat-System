Rails.application.routes.draw do
  
  # creating application.
  post "/application/create/:name", to: "applications#create"
    
  # get specific application
  get "/application/show/:application_token", to: "applications#show"
  
  # get all chats description
  get "/application/index", to: "applications#index"

  # Delete an application.
  delete "/application/delete/:application_token", to: "applications#destroy"

  #########################################################################################

  # adding new chat
  post "/application/:application_token/chat/create", to: "chats#create"

  # show all chats
  get "/application/:application_token/chat/index", to: "chats#index"  
  
  # show specific chat
  get "/application/:application_token/chat/show/:Chat_id", to: "chats#show"
  
  # delete a specific chat, with all of its messages 
  delte "/application/:application_token/chat/delete/:Chat_id", to: "chats#destroy"

  ##########################################################################################

  # Add a message.
  post "/application/:application_token/chat/:Chat_id/message/create/:body", to: "messages#create"
  
  # get all messages.
  get "/application/:application_token/chat/:Chat_id/message/index", to: "messages#index"
 
  # get a specific message.
  get "/application/:application_token/chat/:Chat_id/message/show/:message_id", to: "messages#show"

  
  # Update that specific message.
  put "/application/:application_token/chat/:Chat_id/message/update/:message_id/:body", to: "messages#update"

  # Delete that specific message.
  delete "/application/:application_token/chat/:Chat_id/message/delete/:message_id", to: "messages#destroy"
end
