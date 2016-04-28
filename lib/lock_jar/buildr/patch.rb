require 'buildr'
require 'lock_jar'
require 'lock_jar/domain/dsl'
require 'lock_jar/buildr/project_extension'

module Buildr

  class << self
    attr_accessor :global_lockjar_dsl

    def project_to_lockfile( project )
      "#{project.name.gsub(/:/,'-')}.lock"
    end
  end

  def lock_jar( &blk )
   Buildr.global_lockjar_dsl = ::LockJar::Domain::Dsl.create(&blk)
  end

  namespace "lock_jar" do
    desc "Lock dependencies for each project"
    task("lock") do
      projects.each do |project|
        if project.lockjar_dsl
          # add buildr repos
          repositories.remote.each do |repo|
            project.lockjar_dsl.repository repo
          end
          ::LockJar.lock( project.lockjar_dsl, lockfile: ::Buildr.project_to_lockfile(project) )
        end
      end
    end
  end
end

class Buildr::Project
  include LockJar::Buildr::ProjectExtension
end
