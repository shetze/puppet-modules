require 'spec_helper'
describe 'buildhost' do

  context 'with defaults for all parameters' do
    it { should contain_class('buildhost') }
  end
end
