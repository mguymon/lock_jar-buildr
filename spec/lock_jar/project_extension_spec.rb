require 'spec_helper'

describe LockJar::Buildr::ProjectExtension do
  let(:lockfile_data) { YAML.load(IO.read(lockfile)) }
  let(:local_repo) { File.join(File.dirname(__FILE__), '..', 'tmp') }

  before do
    FileUtils.mkdir_p(File.join(File.dirname(__FILE__), '..', 'tmp'))
  end

  describe 'task app:lock_jar:lock' do
    subject! do
      # app definition, inherited into all projects
      lock_jar do
        local_repo File.join(File.dirname(__FILE__), '..', 'tmp')

        group 'test' do
          jar 'junit:junit:jar:4.12'
        end
      end

      define 'app' do
        # inherits project defaults
      end
    end

    let(:lockfile) { subject._('app.lock') }
    let(:expected_lockfile_data) do
      {
        'groups' => {
          'default' => {
            'dependencies' => [],
            'artifacts' => []
          },
          'test' => {
            'dependencies' => ['junit:junit:jar:4.12', 'org.hamcrest:hamcrest-core:jar:1.3'],
            'artifacts' => [
              {
                'jar:junit:junit:jar:4.12' => {
                  'transitive' => {
                    'org.hamcrest:hamcrest-core:jar:1.3' => {}
                  }
                }
              }
            ]
          }
        },
        'local_repository' => local_repo,
        'remote_repositories' => ['http://repo1.maven.org/maven2/']
      }
    end

    before { task('app:lock_jar:lock').invoke }

    it 'should generate the application lock' do
      expect(File).to exist(lockfile)
      expect(lockfile_data).to include(expected_lockfile_data)
    end
  end

  describe 'task project_with_dsl:lock_jar:lock' do
    subject! do
      define 'project_with_dsl' do
        lock_jar do
          local_repo File.join(File.dirname(__FILE__), '..', 'tmp')
          jar 'junit:junit:jar:4.12'
        end
      end
    end

    let(:lockfile) { subject._('project_with_dsl.lock') }
    let(:expected_lockfile_data) do
      {
        'groups' => {
          'default' => {
            'dependencies' => ['junit:junit:jar:4.12', 'org.hamcrest:hamcrest-core:jar:1.3'],
            'artifacts' => [
              {
                'jar:junit:junit:jar:4.12' => {
                  'transitive' => {
                    'org.hamcrest:hamcrest-core:jar:1.3' => {}
                  }
                }
              }
            ]
          }
        },
        'local_repository' => local_repo,
        'remote_repositories' => ['http://repo1.maven.org/maven2/']
      }
    end

    before { task('project_with_dsl:lock_jar:lock').invoke }

    it 'should generate the project lock' do
      expect(File).to exist(lockfile)
      expect(lockfile_data).to include(expected_lockfile_data)
    end
  end

  describe 'task project_with_pom:lock_jar:lock' do
    subject! do
      define 'project_with_pom' do
        lock_jar do
          local_repo File.join(File.dirname(__FILE__), '..', 'tmp')
          pom File.join(File.dirname(__FILE__), '..', 'fixtures/pom.xml')
        end
      end
    end

    let(:pom_file) { File.join(File.dirname(__FILE__), '..', 'fixtures/pom.xml') }
    let(:lockfile) { subject._('project_with_pom.lock') }
    let(:expected_lockfile_data) do
      {
        'local_repository' => local_repo,
        'groups' => {
          'default' => {
            'dependencies' => %w(junit:junit:jar:4.12 org.hamcrest:hamcrest-core:jar:1.3),
            'artifacts' => [
              {
                "pom:#{pom_file}" => {
                  'scopes' => %w(runtime compile),
                  'transitive' => {
                    'junit:junit:jar:4.12' => {
                      'org.hamcrest:hamcrest-core:jar:1.3' => {}
                    }
                  }
                }
              }
            ]
          }
        },
        'remote_repositories' => ['http://repo1.maven.org/maven2/']
      }
    end

    before { task('project_with_pom:lock_jar:lock').invoke }

    it 'should generate the project lock' do
      expect(File).to exist(lockfile)
      expect(lockfile_data).to include(expected_lockfile_data)
    end
  end
end
