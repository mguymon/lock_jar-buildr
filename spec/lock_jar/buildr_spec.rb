require 'spec_helper'

describe LockJar::Buildr do
  it 'has a version number' do
    expect(LockJar::Buildr::VERSION).not_to be nil
  end
end

describe Buildr do
  describe '.global_lockjar_dsl' do
    it 'should patch ::Buildr to add a global dsl' do
      expect(described_class.global_lockjar_dsl).to be_nil
    end
  end

  describe '.project_to_lockfile' do
    let(:fake_project) { double(:project, name: 'a:fancy:project') }

    it 'should patch ::Buildr to add a project to lockfile helper' do
      expect(described_class.project_to_lockfile(fake_project)).to(
        eq 'a-fancy-project.lock'
      )
    end
  end
end
