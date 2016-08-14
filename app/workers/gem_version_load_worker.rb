class GemVersionLoadWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(gem_name, version_data)
    url = "https://rubygems.org/downloads/#{gem_name}-#{version_data['number']}.gem"
    Rails.logger.info("Start loading gem version. Gem: #{gem_name}, url: #{url}, version: #{version_data}")
    gv = GemVersion.new(name: gem_name, version: version_data['number'], sha: version_data['sha'])
    gv.remote_gem_copy_url = url
    gv.save!
  end
end
