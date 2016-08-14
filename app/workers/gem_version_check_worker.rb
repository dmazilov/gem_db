class GemVersionCheckWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(gem_version_id)
    gv = GemVersion.find(gem_version_id)
    if gv.blank?
      raise StandardError.new, "Oops! GemVersion with id = #{gem_version_id} does not exist!"
    end
    Rails.logger.info("Start checking gem version. Gem version data: #{gv}")
    path = gv.gem_copy.current_path
    unless File.exist?(path)
      raise GemVersion::Exceptions::GemCopyMissingError.new, "There is no gem copy at path #{path}!"
    end
    if Rickshaw::SHA256.hash(gv.gem_copy.current_path) != gv.sha
      raise GemVersion::Exceptions::SHAMismatchError.new, "Gem copy at path #{path} does not match to original file!"
    end
  end
end
