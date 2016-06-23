require 'spec_helper'
describe 'appserver' do

  context 'with defaults for all parameters' do
    it { should contain_class('appserver') }
  end
end
