# frozen_string_literal: true

module Api
  module Internal
    class GraphqlController < ActionController::Base
      include Analyzable
      include LogrageSetting
      include RavenContext
      include Localable

      before_action :set_locale

      def execute
        variables = ensure_hash(params[:variables])
        query = params[:query]
        context = {
          writable: true,
          admin: true,
          viewer: current_user
        }
        result = ::Canary::AnnictSchema.execute(query, variables: variables, context: context)
        render json: result
      end

      private

      # Handle form data, JSON body, or a blank value
      def ensure_hash(ambiguous_param)
        case ambiguous_param
        when String
          if ambiguous_param.present?
            ensure_hash(JSON.parse(ambiguous_param))
          else
            {}
          end
        when Hash, ActionController::Parameters
          ambiguous_param
        when nil
          {}
        else
          raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
        end
      end

      def set_locale
        return if user_signed_in?

        I18n.locale = domain_jp? ? :ja : :en
      end
    end
  end
end