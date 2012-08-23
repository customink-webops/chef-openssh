require 'spec_helper'

recipe = "chef-openssh::default"

describe recipe do
  before(:all) do
    # Set variables to be used by tests here
    #
    @vcl_files = %w(default backends error_page extended_cache_control)
    @fe_vips = [ "10.0.1.170" ]
    @clipart_vips = [ "10.0.1.171" ]
    @hanes4ed_vips = [ "10.0.1.172" ]
    @blog_vips = [ "10.0.1.173" ]
    @sales_vips = [ "10.0.1.19" ]
    @iotw_vips = [ "10.0.1.20" ]
    # Fauxhai.mock(platform:'ubuntu', version:'12.04') do |node|
    #       # Set node attributes
    #       node['mongodb'] = Hash.new
    #       node['mongodb']['mongods'] = @mongodbs
    #       node['mongodb']['binaries'] = @mongo_binary_path
    #       node['mongodb']['run_backups'] = true
    #     end
    # @chef_run = ChefSpec::ChefRunner.new.converge(recipe)
    @chef_run = ChefSpec::ChefRunner.new
  end
  
  before :each do
    @chef_run.node.stub(:search).with(:node, "role:www-lb AND chef_environment:production").and_return([{'hostname' => 'www-lb01.dc.customink.com'}])
    Fauxhai.mock(platform:'ubuntu', version:'12.04') do |node|
              # Set node attributes
              node['mongodb'] = Hash.new
              node['mongodb']['mongods'] = @mongodbs
              node['mongodb']['binaries'] = @mongo_binary_path
              node['mongodb']['run_backups'] = true
            end
    @chef_run.converge(recipe)
  end
  
  it "Should start ssh" do
    @chef_run.should start_service 'ssh'
  end
  
  it "Should create /etc/ssh/sshd_config" do
    @chef_run.should create_file "/etc/ssh/sshd_config"
  end

end

