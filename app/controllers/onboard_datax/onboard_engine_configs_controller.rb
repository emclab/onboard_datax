require_dependency "onboard_datax/application_controller"

module OnboardDatax
  class OnboardEngineConfigsController < ApplicationController
    before_filter :require_employee
    before_filter :load_record
    
    def index
      @title = t('Onboard Engine Configs')
      @onboard_engine_configs =  params[:onboard_datax_onboard_engine_configs][:model_ar_r]
      @onboard_engine_configs = @onboard_engine_configs.where('onboard_datax_onboard_engine_configs.project_id = ?', @project.id) if @project
      @onboard_engine_configs = @onboard_engine_configs.where('onboard_datax_onboard_engine_configs.engine_id = ?', @engine.id) if @engine
      @onboard_engine_configs = @onboard_engine_configs.where('onboard_datax_onboard_engine_configs.release_id = ?', @release.id) if @release
      @erb_code = find_config_const('onboard_engine_config_index_view', 'onboard_datax')
      @engine_boarded = engine_boarded(@onboard_engine_configs, OnboardDatax.project_misc_definition_class.where('project_id = ? AND definition_category = ?', @project.id, 'release')) if @project
      #for csv download
      respond_to do |format|
        format.html {@onboard_engine_configs = @onboard_engine_configs.page(params[:page]).per_page(@max_pagination) }
        format.csv do
          send_data @onboard_engine_configs.to_csv
          @csv = true
        end #if @release
      end
    end

    def new
      @title = t('New Onboard Engine Config')
      @onboard_engine_config = OnboardDatax::OnboardEngineConfig.new
      @erb_code = find_config_const('onboard_engine_config_new_view', 'onboard_datax')
    end


    def create
      @onboard_engine_config = OnboardDatax::OnboardEngineConfig.new(params[:onboard_engine_config], :as => :role_new)
      @onboard_engine_config.last_updated_by_id = session[:user_id]
      @onboard_engine_config.custom_argument_value = @onboard_engine_config.custom_argument_value.strip if @onboard_engine_config.custom_argument_value.present?
      if @onboard_engine_config.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        flash[:notice] = t('Data Error. Not Saved!')
        @engine_config = OnboardDatax.engine_config_class.find_by_id(params[:onboard_engine_config][:engine_config_id].to_i) if params[:onboard_engine_config][:engine_config_id].present?
        @project = OnboardDatax.project_class.find_by_id(params[:onboard_engine_config][:project_id]) if params[:onboard_engine_config][:project_id].present?
        @engine = OnboardDatax.engine_class.find_by_id(params[:onboard_engine_config][:engine_id].to_i) if params[:onboard_engine_config][:engine_id].present?
        @erb_code = find_config_const('onboard_engine_config_new_view', 'onboard_datax')
        render 'new'
      end
    end

    def edit
      @title = t('Edit Onboard Engine Config')
      @onboard_engine_config = OnboardDatax::OnboardEngineConfig.find_by_id(params[:id])
      @erb_code = find_config_const('onboard_engine_config_edit_view', 'onboard_datax')
    end

    def update
        @onboard_engine_config = OnboardDatax::OnboardEngineConfig.find_by_id(params[:id])
        @onboard_engine_config.last_updated_by_id = session[:user_id]
        params[:onboard_engine_config][:custom_argument_value] = params[:onboard_engine_config][:custom_argument_value].strip if params[:onboard_engine_config][:custom_argument_value].present? 
        if @onboard_engine_config.update_attributes(params[:onboard_engine_config], :as => :role_update)
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
        else
          flash[:notice] = t('Data Error. Not Updated!')
          @erb_code = find_config_const('onboard_engine_config_edit_view', 'onboard_datax')
          render 'edit'
        end
    end

    def show
      @title = t('Onboard Engine Config Info')
      @onboard_engine_config = OnboardDatax::OnboardEngineConfig.find_by_id(params[:id])
      @engine_config = OnboardDatax.engine_config_class.find_by_id(@onboard_engine_config.engine_config_id)
      @erb_code = find_config_const('onboard_engine_config_show_view', 'onboard_datax')
    end
    
    def destroy  
      OnboardDatax::OnboardEngineConfig.delete(params[:id].to_i)
      redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Deleted!")
    end
    
    def copy
      @title = t('Copy from Another Project')
      @from_projects = OnboardDatax.project_class.where('id != ?', @project.id).order('id DESC')
      engine_ids = eval(OnboardDatax.engine_ids_belong_to_a_project) #if @project_id #engine_id
      @engines = OnboardDatax.engine_class.where(active: true).where(:id => engine_ids).order('name')
      @to_release = OnboardDatax.project_misc_definition_class.where(definition_category: 'release').where(project_id: @project.id).map{|r| [r.name, r.id]}
      @erb_code = find_config_const('onboard_engine_config_copy_view', 'onboard_datax')
      @js_erb_code = find_config_const('onboard_engine_config_copy_view_field', 'onboard_datax')
    end
    
    def copy_results
      project_id = params[:save].keys[0]
      from_project_id = params[:pid_from].to_i if params[:pid_from].present?
      from_engine = params[:from_engine].to_i if params[:from_engine]
      release_from = params[:release_from].to_i if params[:release_from]
      release_to = params[:release_to].to_i if params[:release_to]
      to_engine = params[:to_engine].to_i if params[:to_engine]
      OnboardDatax::OnboardEngineConfig.where('onboard_datax_onboard_engine_configs.project_id = ? AND onboard_datax_onboard_engine_configs.engine_id = ? AND release_id = ?', 
                                              from_project_id, from_engine, release_from).each do |base|
        onboard_item = OnboardDatax::OnboardEngineConfig.new
        onboard_item.engine_config_id = base.engine_config_id
        onboard_item.engine_id = base.engine_id
        onboard_item.project_id = project_id
        onboard_item.custom_argument_value = base.custom_argument_value
        onboard_item.last_updated_by_id = session[:user_id]
        onboard_item.release_id = release_to
        begin
          onboard_item.save
        rescue => e
          flash[:notice] = 'Base#=' + base.id.to_s  + ',' + e.message
        end
      end if project_id && from_project_id && from_engine  && release_from && release_to && to_engine && (from_engine == to_engine)
      redirect_to  SUBURI + "/view_handler?index=1&url=#{onboard_engine_configs_path(project_id: project_id)}"
    end
    
    protected
    def load_record
      @engine_config = OnboardDatax.engine_config_class.find_by_id(params[:engine_config_id].to_i) if params[:engine_config_id].present?
      @engine_config = OnboardDatax.engine_config_class.find_by_id(OnboardDatax::OnboardEngineConfig.find_by_id(params[:id].to_i).engine_config_id) if params[:id].present?
      @project = OnboardDatax.project_class.find_by_id(params[:project_id]) if params[:project_id].present?
      @project = OnboardDatax.project_class.find_by_id(OnboardDatax::OnboardEngineConfig.find_by_id(params[:id]).project_id) if params[:id].present?      
      @engine = OnboardDatax.engine_class.find_by_id(params[:engine_id].to_i) if params[:engine_id].present?
      @engine = OnboardDatax.engine_class.find_by_id(OnboardDatax::OnboardEngineConfig.find_by_id(params[:id]).engine_id) if params[:id].present?
      @release = OnboardDatax.project_misc_definition_class.find_by_id(params[:release_id]) if params[:release_id].present?
      @release = OnboardDatax.project_misc_definition_class.find_by_id(params[:from_release].to_i) if params[:from_release].present?  #csv download
      @release = OnboardDatax.project_misc_definition_class.find_by_id(OnboardDatax::OnboardEngineConfig.find_by_id(params[:id]).release_id) if params[:id].present?
    end
    
  end
end
