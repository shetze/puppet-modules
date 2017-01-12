require 'spec_helper'
describe 'shop' do

  context 'with defaults for all parameters' do
    it { should contain_class('shop') }
  end
end
