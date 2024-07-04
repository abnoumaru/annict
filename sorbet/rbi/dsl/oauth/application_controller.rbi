# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for dynamic methods in `Oauth::ApplicationController`.
# Please instead update this file by running `bin/tapioca dsl Oauth::ApplicationController`.


class Oauth::ApplicationController
  include GeneratedUrlHelpersModule
  include GeneratedPathHelpersModule

  sig { returns(HelperProxy) }
  def helpers; end

  module HelperMethods
    include ::Ransack::Helpers::FormHelper
    include ::ActionController::Base::HelperMethods
    include ::ApplicationHelper
    include ::ComponentValueFetcherHelper
    include ::Db::ApplicationHelper
    include ::EpisodesHelper
    include ::GaHelper
    include ::HeadHelper
    include ::IcalendarHelper
    include ::IconHelper
    include ::ImageHelper
    include ::LocalHelper
    include ::MarkdownHelper
    include ::RecordsHelper
    include ::StaffsHelper
    include ::TimeZoneHelper
    include ::UrlHelper
    include ::VodHelper
    include ::WorksHelper
    include ::PreviewHelper
    include ::Doorkeeper::DashboardHelper
    include ::DeviseHelper

    sig { returns(T.untyped) }
    def client_uuid; end

    sig { params(locale: T.untyped).returns(T.untyped) }
    def local_url_with_path(locale: T.unsafe(nil)); end

    sig { params(resources: T.untyped).returns(T.untyped) }
    def localable_resources(resources); end

    sig { returns(T.untyped) }
    def locale_en?; end

    sig { returns(T.untyped) }
    def locale_ja?; end

    sig { returns(T.untyped) }
    def page_category; end
  end

  class HelperProxy < ::ActionView::Base
    include HelperMethods
  end
end
