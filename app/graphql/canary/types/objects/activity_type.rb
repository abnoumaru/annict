# frozen_string_literal: true

module Canary
  module Types
    module Objects
      class ActivityType < Canary::Types::Objects::Base
        implements GraphQL::Relay::Node.interface

        global_id_field :id

        field :annict_id, Integer, null: false
        field :user, Canary::Types::Objects::UserType, null: false

        def user
          RecordLoader.for(User).load(object.user_id)
        end
      end
    end
  end
end
