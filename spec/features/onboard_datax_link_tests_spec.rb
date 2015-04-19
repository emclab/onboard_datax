require 'spec_helper'

describe "LinkTests" do
  describe "GET /onboard_datax_link_tests" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link'
        }
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      #engine config
      user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'onboard_datax_onboard_engine_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "OnboardDatax::OnboardEngineConfig.scoped.order('created_at DESC')")
      user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'onboard_datax_onboard_engine_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'onboard_datax_onboard_engine_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'onboard_datax_onboard_engine_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'destroy', :resource =>'onboard_datax_onboard_engine_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        #init
      user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'onboard_datax_onboard_engine_inits', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "OnboardDatax::OnboardEngineInit.scoped.order('created_at DESC')")
      user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'onboard_datax_onboard_engine_inits', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'onboard_datax_onboard_engine_inits', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'onboard_datax_onboard_engine_inits', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'destroy', :resource =>'onboard_datax_onboard_engine_inits', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "") 
      #user access
      user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'onboard_datax_onboard_user_accesses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "OnboardDatax::OnboardUserAccess.scoped.order('created_at DESC')")
      user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'onboard_datax_onboard_user_accesses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'onboard_datax_onboard_user_accesses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'onboard_datax_onboard_user_accesses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'destroy', :resource =>'onboard_datax_onboard_user_accesses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      #search/stat 
      user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'onboard_datax_onboard_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "OnboardDatax::OnboardSearchStatConfig.scoped.order('created_at DESC')")
      user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'onboard_datax_onboard_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'onboard_datax_onboard_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'onboard_datax_onboard_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'destroy', :resource =>'onboard_datax_onboard_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
         
      @proj = FactoryGirl.create(:info_service_projectx_project)
      @engine = FactoryGirl.create(:sw_module_infox_module_info, :name => 'myengine', :active => true)
      @engine1 = FactoryGirl.create(:sw_module_infox_module_info, :active => true)
      
      @user_access = FactoryGirl.create(:onboard_data_uploadx_user_access, :engine_id => @engine.id, :access_desp => 'new new')
      @user_access1 = FactoryGirl.create(:onboard_data_uploadx_user_access, :engine_id => @engine1.id, action: 'new act')
      @role = FactoryGirl.create(:project_misc_definitionx_misc_definition)
      #
      @engine_config = FactoryGirl.create(:onboard_data_uploadx_engine_config, :engine_id => @engine.id, :argument_desp => 'new new')
      @engine_config1 = FactoryGirl.create(:onboard_data_uploadx_engine_config, :engine_id => @engine1.id)
      #
      @search_stat = FactoryGirl.create(:onboard_data_uploadx_search_stat_config, :engine_id => @engine.id, :resource_name => 'new new')
      @search_stat1 = FactoryGirl.create(:onboard_data_uploadx_search_stat_config, :engine_id => @engine1.id)
      #
      @init = FactoryGirl.create(:onboard_data_uploadx_engine_init, :engine_id => @engine.id)
      @init1 = FactoryGirl.create(:onboard_data_uploadx_engine_init, :engine_id => @engine1.id)
      
      @release = FactoryGirl.create(:project_misc_definitionx_misc_definition, project_id: @proj.id, definition_category: 'release', name: 'rel name' )
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => @u.password
      click_button 'Login'
    end
    it "works for engine config" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      #visit onboard_engine_configs_path
      #save_and_open_page
      task = FactoryGirl.create(:onboard_datax_onboard_engine_config, :project_id => @proj.id, :engine_config_id => @engine_config.id, :last_updated_by_id => @u.id, release_id: @release.id)
      visit onboard_engine_configs_path
      #save_and_open_page
      page.should have_content('Onboard Engine Configs')
      click_link 'Edit'
      #save_and_open_page
      page.should have_content('Edit Onboard Engine Config')
      #save_and_open_page
      fill_in 'onboard_engine_config_custom_argument_value', :with => '230'
      click_button "Save"
      #no bad data
      
      #show
      visit onboard_engine_configs_path()
      #save_and_open_page
      click_link task.id.to_s
      #save_and_open_page
      page.should have_content('Onboard Engine Config Info')
      
      #new
      visit onboard_engine_configs_path(:engine_config_id => @engine_config1.id, :engine_id => @engine.id, :project_id => @proj.id, release_id: @release.id)
      click_link 'New Onboard Engine Config'
      #save_and_open_page
      page.should have_content('New Onboard Engine Config')
      fill_in 'onboard_engine_config_custom_argument_value', :with =>  'argument value 230'
      select('rel name', from: 'onboard_engine_config_release_id')
      click_button 'Save'
      #save_and_open_page
      #no bad data
      visit onboard_engine_configs_path()
      save_and_open_page
      page.should have_content('argument value 230'[0..5])
      
      #download, ex csv
      visit onboard_engine_configs_path(project_id:  @proj.id)
      click_button 'CSV'
      page.should have_content("id,engine_name,engine_version,argument_name,argument_value,last_updated_by_id,created_at,updated_at,")
      
      #no download without @proj
      visit onboard_engine_configs_path
      page.should_not have_content('CSV')
    end
    
    it "works for user access" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      task = FactoryGirl.create(:onboard_datax_onboard_user_access, :project_id => @proj.id, :user_access_id => @user_access.id, :role_definition_id => @role.id, release_id: @release.id, :last_updated_by_id => @u.id)
      visit onboard_user_accesses_path
      #save_and_open_page
      page.should have_content('Onboard User Accesses')
      click_link 'Edit'
      #save_and_open_page
      page.should have_content('Edit Onboard User Access')
      #no edit at all
      
      #show
      visit onboard_user_accesses_path
      #save_and_open_page
      click_link task.id.to_s
      save_and_open_page
      page.should have_content('Onboard User Access Info')
      
      #new
      visit new_onboard_user_access_path(:project_id => @proj.id)
      #save_and_open_page
      page.should have_content('New Onboard User Access')
      #no fill in at all for new
      
      #download, ex CSV
      visit onboard_user_accesses_path(project_id: @proj.id)
      click_button 'CSV'
      page.should have_content("id,action,resource,brief_note,last_updated_by_id,role_definition_id,sql_code,masked_attrs")
      
      #no download without @proj
      visit onboard_user_accesses_path
      page.should_not have_content("CSV")
    end
    
    it "works for engine init" do
      task = FactoryGirl.create(:onboard_datax_onboard_engine_init, :project_id => @proj.id, :engine_init_id => @init.id, :last_updated_by_id => @u.id, release_id: @release.id)
      visit onboard_engine_inits_path
      #save_and_open_page
      page.should have_content('Onboard Engine Inits')
      click_link 'Edit'
      #no edit at all
      
      #show
      visit onboard_engine_inits_path
      #save_and_open_page
      click_link task.id.to_s
      #save_and_open_page
      page.should have_content('Onboard Engine Init Info')
      
      #new
      visit new_onboard_engine_init_path(:project_id => @proj.id)
      #save_and_open_page
      page.should have_content('New Onboard Engine Init')
      #no fill in at all
      
    end
    
    it "works for search stat config" do
      task = FactoryGirl.create(:onboard_datax_onboard_search_stat_config, :project_id => @proj.id, :search_stat_config_id => @search_stat.id, :last_updated_by_id => @u.id, release_id: @release.id)
      visit onboard_search_stat_configs_path(:project_id => @proj.id)
      #save_and_open_page
      page.should have_content('Onboard Search/Stat Configs')
      click_link 'Edit'
      save_and_open_page
      page.should have_content('Edit Onboard Search/Stat Config')
      #save_and_open_page
      fill_in 'onboard_search_stat_config_custom_stat_summary_function', :with => '230'
      click_button "Save"
      #no bad data
      
      #show
      visit onboard_search_stat_configs_path
      #save_and_open_page
      click_link task.id.to_s
      #save_and_open_page
      page.should have_content('Onboard Search/Stat Config Info')
      
      #new
      visit new_onboard_search_stat_config_path(:search_stat_config_id => @search_stat1.id, :engine_id => @engine.id, :project_id => @proj.id)
      save_and_open_page
      page.should have_content('New Onboard Search/Stat Config')
      fill_in 'onboard_search_stat_config_custom_stat_summary_function', :with => 'summary 230'
      fill_in 'onboard_search_stat_config_custom_stat_header', :with => 'this is a new header'
      select('rel name', :from => 'onboard_search_stat_config_release_id')
      click_button 'Save'
      #save_and_open_page
      #no bad data
      
      visit onboard_search_stat_configs_path
      
      page.should have_content('summary 230'[0..5])
      
      #download, ex CSV
      visit onboard_search_stat_configs_path(project_id: @proj.id)
      click_button 'CSV'
      page.should have_content("id,resource_name,stat_function,stat_summary_function,labels_and_fields")
      
      #no download without @proj
      visit onboard_search_stat_configs_path
      page.should_not have_content('CSV')
    end
  end
end
