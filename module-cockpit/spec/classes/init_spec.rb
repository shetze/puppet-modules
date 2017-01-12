require 'spec_helper'
describe 'cockpit' do

  context 'with defaults for all parameters' do
    it { should contain_class('cockpit') }
  end
end
