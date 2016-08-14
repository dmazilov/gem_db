class GemVersionsController < ApplicationController
  def index
    @gem_versions = GemVersion.all
  end
end
