require 'spec_helper'
describe 'dockerhost' do

  context 'with defaults for all parameters' do
    it { should contain_class('dockerhost') }
  end
end
