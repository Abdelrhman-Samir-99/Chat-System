# Instabug Task #

## System requirements ##
+ Creating applications with unique tokens.
+ Creating chats using an application token, with a unique ID.
+ Use ElasticSearch to search messages partially.
+ Use a message queue to handle loads.

## Notes ##
+ I used ROR v6 and SQLite.
+ I had never done anything before using ROR.

## Database (Models) ##

Each table is a model.

![dbSchema](https://user-images.githubusercontent.com/77211992/150012374-2260b7ed-fe86-48b1-84a4-f1ffd9f4d868.png)


+ there is a flaw in the logic.
    + I use chats_count + 1 to generate the Chat_id and the same for Message_id by using messages_count.
    + The flaw happens when we delete a chat or a message then add a new entity.
        + if we have chats {1, 2, 3} and chats_count = 3
        + if we remove the first chat -> {2, 3} and chats_count = 2
        + adding a new chat -> {2, 3, 3} and chats_count = 3.
    + this bug can be fixed by adding a new indepndent column in message and chat models, to keep track of the total number.
    + I will fix it, but After the deadline (because I just thought about it).
+ We can add some indecies to optimze some search queries if we won't use elasticsearch.
+ I also maintained the referential integrity (first I did that manually, then I learned how to let ActiveRecord handle it).
+ I tried not to write duplicate steps, by creating methods for each model. But I had problems with parameters (not sure, but it was automatically casted to array instead of a hash) and I'm not able to solve it "yet".
## Controllers ##
+ ApplicationsController: Handling everything related to the application
+ ChatsController: Handling everything related to the chat.
+ MessagesController: Handling everyhing related to the message.
## Routes ##
+ Application routes:
    + POST methods:
        + `/application/create/:name` Creating a new application.
    + GET methods:
        + `/application/index` Shows all applications.
        + `/application/show/:application_token` Shows a specific application.
    + DELETE methods:
        + `/application/delete/:application_token` Delete a specific application with all of its chats and messages.
+ Chat routes:
    + POST methods:
        + `application/:application_token/chat/create` Creating a new chat in a specific application.
    + GET methods:
        + `/application/:application_token/chat/index` Shows all chats in a specific application.
        + `/application/:application_token/chat/show/:Chat_id` Shows a specific chat using Chat_ID.
    + DELETE methods: 
        + `/application/:application_token/chat/delete/:Chat_id` Delete a specific chat with is messages.
+ Message routes:
    + POST methods: 
        + `/application/:application_token/chat/:Chat_id/message/create/:body` Creating a new message.
    + GET methods: 
        + `/application/:application_token/chat/:Chat_id/message/index` Shows all messages for a specfic chat.
        + `/application/:application_token/chat/:Chat_id/message/show/:message_id` Shows a specfic message in a specific chat.
    + PUT methods: 
        + `/application/:application_token/chat/:Chat_id/message/update/:message_id/:body` Updating a specific message.
    + DELETE methods: 
        + `/application/:application_token/chat/:Chat_id/message/delete/:message_id` Delete a specific message.

## ElasticSearch ##
+ I couldn't complete this task fully, but I wantched the first two lectures for the ElasticSearch on their official youtube channel and also I was following this [blog](https://iridakos.com/programming/2017/12/03/elasticsearch-and-rails-tutorial), but I had an error when I was creating index for the message model that I couldn't solve (or find a solution).
+ My idea is just to make a single index for the Message model, and elasticsearch will fetch all the messages that are relevant to our query.
    + I'm not sure if we can include the Application_id, Chat_id in our query or not, but if not then we can just filter the JSON result.
    + I had a good experience with Kibana as well.
And I would like to thank you for letting me know about this microservice "I believe".
## Message Queue ##
+ I didn't even have enough time for this, since I had to learn ROR and this is actually my first RESTFul API to implement.
+ I have a little knowledge about message queue and how the handle loads on the server, by serving specific amount of customers/threads and use a database with {key, value} pair to save the result.
+ But since I'm just graduated, and don't really have work experience. I never exposed to a message queue as implementation, but I believe I used it once in Java while doing a multi-threading task.
