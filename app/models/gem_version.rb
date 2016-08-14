require 'rest-client'
require 'carrierwave/orm/activerecord'
class GemVersion < ActiveRecord::Base
  mount_uploader :gem_copy, GemVersionUploader

  validates_presence_of :name, :version, :gem_copy, :sha
  validates_uniqueness_of :version, scope: [:name]

  module Exceptions
    class BaseError < StandardError
      def initialize(message = '')
        super(message)
      end
    end
    class LoadError < BaseError; end
    class GemCopyMissingError < BaseError; end
    class SHAMismatchError < BaseError; end
  end

  def self.load_gem_versions_data(gem_name = 'rails')
    url = "https://rubygems.org/api/v1/versions/#{gem_name}.json"
    request = RestClient.get(url)
    JSON.parse(request.body)
  rescue RestClient::Exception, JSON::ParserError => e
    Rails.logger.error(e.message)
    Rails.logger.error(e.backtrace.join("\n"))
    raise GemVersion::Exceptions::LoadError.new, "Can't load data for gem #{gem_name}. Check response from url #{url}"
  end
end
