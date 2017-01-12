require 'spec_helper'
describe 'hypervisor' do

  context 'with defaults for all parameters' do
    it { should contain_class('hypervisor') }
  end
end
