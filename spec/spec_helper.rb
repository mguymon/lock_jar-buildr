$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pry'
require 'lock_jar/buildr'

# hook into buildr's spec_helpers load process
module SandboxHook
  def self.included(_)
    $LOAD_PATH.unshift(File.dirname(__FILE__))
    $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
    require 'lock_jar/buildr'
  end
end

buildr_gem_spec = Gem::Specification.find_by_name('buildr')
require File.join(buildr_gem_spec.gem_dir, '/spec/spec_helpers')
