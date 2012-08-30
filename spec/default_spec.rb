require 'spec_helper'

recipe = 'chef-openssh::default'

describe recipe do
  before(:all) do
    @vcl_files = %w(default backends error_page extended_cache_control)
    @fe_vips = [ '10.0.1.170' ]
    @clipart_vips = [ '10.0.1.171' ]
    @hanes4ed_vips = [ '10.0.1.172' ]
    @blog_vips = [ '10.0.1.173' ]
    @sales_vips = [ '10.0.1.19' ]
    @iotw_vips = [ '10.0.1.20' ]
  end

  before(:each) do
    # create the runner
    @runner = ChefSpec::ChefRunner.new

    # stub the search
    @runner.node.stub(:search).with(:node, 'role:www-lb AND chef_environment:production').and_return([{'hostname' => 'www-lb01.dc.customink.com'}])

    # mock out the data
    Fauxhai.mock(platform:'ubuntu', version:'12.04') do |node|
      node['mongodb'] = {}
      node['mongodb']['mongods'] = @mongodbs
      node['mongodb']['binaries'] = @mongo_binary_path
      node['mongodb']['run_backups'] = true
    end

    # now converge
    @runner.converge(recipe)
  end

  it 'should start ssh' do
    @runner.should start_service 'ssh'
  end

  it 'should create /etc/ssh/sshd_config' do
    @runner.should create_file '/etc/ssh/sshd_config'
  end
end

