require 'spec_helper'

module OnboardDatax
  describe OnboardSearchStatConfigsController do
    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
    end
    
    before(:each) do
      
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      @proj = FactoryGirl.create(:info_service_projectx_project)
      @sw_mod = FactoryGirl.create(:sw_module_infox_module_info)
      @sw_mod1 = FactoryGirl.create(:sw_module_infox_module_info, :name => 'a new name')
      @engine_config = FactoryGirl.create(:onboard_data_uploadx_search_stat_config, :engine_id => @sw_mod.id, :resource_name => 'new new')
      @engine_config1 = FactoryGirl.create(:onboard_data_uploadx_search_stat_config, :engine_id => @sw_mod1.id)
      @release = FactoryGirl.create(:project_misc_definitionx_misc_definition, project_id: @proj.id, definition_category: 'release', name: 'rel name')
    end
    
    render_views
    
    describe "GET 'index'" do
      it "returns all onboard engine configs" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'onboard_datax_onboard_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "OnboardDatax::OnboardSearchStatConfig.scoped.order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:onboard_datax_onboard_search_stat_config, :search_stat_config_id => @engine_config.id, :last_updated_by_id => @u.id, release_id: @release.id)
        q1 = FactoryGirl.create(:onboard_datax_onboard_search_stat_config, :project_id => q.project_id + 1, :search_stat_config_id =>  @engine_config1.id, :last_updated_by_id => @u.id, release_id: @release.id )
        get 'index', {:use_route => :onboard_datax}
        assigns(:onboard_search_stat_configs).should =~ [q, q1]
      end
      
      it "should only return the engine configs which belongs to an engine" do       
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'onboard_datax_onboard_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "OnboardDatax::OnboardSearchStatConfig.scoped.order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:onboard_datax_onboard_search_stat_config, :search_stat_config_id => @engine_config.id, :last_updated_by_id => @u.id, release_id: @release.id)
        q1 = FactoryGirl.create(:onboard_datax_onboard_search_stat_config, :engine_id => @sw_mod.id + 1, :search_stat_config_id =>  @engine_config1.id, :last_updated_by_id => @u.id, release_id: @release.id)
        get 'index', {:use_route => :onboard_datax, :engine_id => @sw_mod.id}
        assigns(:onboard_search_stat_configs).should =~ [q]
      end
      
      it "should return configs which belong to project" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'onboard_datax_onboard_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "OnboardDatax::OnboardSearchStatConfig.scoped.order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:onboard_datax_onboard_search_stat_config,  :search_stat_config_id => @engine_config.id, :project_id => @proj.id, :last_updated_by_id => @u.id, release_id: @release.id)
        q1 = FactoryGirl.create(:onboard_datax_onboard_search_stat_config, :engine_id => q.engine_id + 1, :search_stat_config_id => @engine_config1.id, :project_id => q.project_id + 1, :last_updated_by_id => @u.id, release_id: @release.id)
        get 'index', {:use_route => :onboard_datax, :project_id => @proj.id}
        assigns(:onboard_search_stat_configs).should =~ [q]
      end
      
      it "should return configs which belong to release" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'onboard_datax_onboard_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "OnboardDatax::OnboardSearchStatConfig.scoped.order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:onboard_datax_onboard_search_stat_config,  :search_stat_config_id => @engine_config.id, :release_id => @release.id, :last_updated_by_id => @u.id)
        q1 = FactoryGirl.create(:onboard_datax_onboard_search_stat_config, :engine_id => q.engine_id + 1, :search_stat_config_id => @engine_config1.id, :release_id => q.release_id + 1, :last_updated_by_id => @u.id)
        get 'index', {:use_route => :onboard_datax, :release_id => @release.id}
        assigns(:onboard_search_stat_configs).should =~ [q]
      end
      
    end
  
    describe "GET 'new'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'onboard_datax_onboard_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new', {:use_route => :onboard_datax, :project_id => @proj.id, :engine_id => @sw_mod.id, :search_stat_config_id => @engine_config.id}
        response.should be_success
      end
    end
  
    describe "GET 'create'" do
      it "returns redirect with success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'onboard_datax_onboard_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.attributes_for(:onboard_datax_onboard_search_stat_config, :search_stat_config_id => @engine_config.id, :project_id => @proj.id, :engine_id => @sw_mod.id)
        get 'create', {:use_route => :onboard_datax, :onboard_search_stat_config => q, :search_stat_config_id => @engine_config.id, :project_id => @proj.id, :engine_id => @sw_mod.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
      
      #no chance for bad data
      
    end
  
    describe "GET 'edit'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'onboard_datax_onboard_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:onboard_datax_onboard_search_stat_config)
        get 'edit', {:use_route => :onboard_datax, :id => q.id}
        response.should be_success
      end
      
    end
  
    describe "GET 'update'" do
      it "should redirect successfully" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'onboard_datax_onboard_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:onboard_datax_onboard_search_stat_config)
        get 'update', {:use_route => :onboard_datax, :id => q.id, :onboard_search_stat_config => {:search_where => 'for biz trip on 4/20'}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
     
    end
  
    describe "GET 'show'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'onboard_datax_onboard_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:onboard_datax_onboard_search_stat_config, :last_updated_by_id => @u.id, :engine_id => @sw_mod.id, :project_id => @proj.id, :search_stat_config_id => @engine_config.id, release_id: @release.id)
        get 'show', {:use_route => :onboard_datax, :id => q.id }
        response.should be_success
      end
    end
    
    describe "GET 'destroy'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'destroy', :resource =>'onboard_datax_onboard_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:onboard_datax_onboard_search_stat_config)
        get 'destroy', {:use_route => :onboard_datax, :id => q.id }
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Deleted!")
      end
    end
  
  end
end
