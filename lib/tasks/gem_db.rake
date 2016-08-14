namespace :gem_db do
  task :populate, [:gem_name] => :environment do |_, args|
    gem_name = args[:gem_name] || 'rails'
    GemVersion.load_gem_versions_data(gem_name).each do |version_data|
      gv = GemVersion.find_by(name: gem_name, version: version_data['number'])
      if gv.present?
        GemVersionCheckWorker.perform_async(gv.id)
      else
        GemVersionLoadWorker.perform_async(gem_name, version_data)
      end
    end
  end
end
