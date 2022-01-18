class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :Application
  belongs_to :Chat
  settings do
    mappings dynamic: false do
      indexes :Application_id, type: :integer
      indexes :Chat_id, type: :integer
      indexes :body, type: :text, analyzer: :english
    end
  end
end
