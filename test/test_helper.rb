ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase

  def test_data_dir
    [Rails.root, 'test', 'data'].join('/')
  end

  def test_data_tmp_dir
    [test_data_dir, 'tmp'].join('/')
  end

  def hairaito_gem_file
    [Rails.root, 'test', 'data', 'hairaito-0.0.3.gem'].join('/')
  end

end
