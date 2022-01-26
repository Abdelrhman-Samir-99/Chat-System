$chats_count_cache = Redis::Namespace.new("my_app", :redis => Redis.new)
$messages_count_cache = Redis::Namespace.new("my_app", :redis => Redis.new)