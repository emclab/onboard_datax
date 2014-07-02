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
      @erb_code = find_config_const('onboard_engine_config_index_view', 'onboard_datax')
      #for csv download
      respond_to do |format|
        format.html {@onboard_engine_configs = @onboard_engine_configs.page(params[:page]).per_page(@max_pagination) }
        format.csv do
          send_data @onboard_engine_configs.to_csv
          @csv = true
        end
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
      @erb_code = find_config_const('onboard_engine_config_copy_view', 'onboard_datax')
    end
    
    def copy_results
      project_id = params[:save].keys[0]
      OnboardDatax::OnboardEngineConfig.where(project_id: params['single_id']).each do |base|
        onboard_item = OnboardDatax::OnboardEngineConfig.new
        onboard_item.engine_config_id = base.engine_config_id
        onboard_item.engine_id = base.engine_id
        onboard_item.project_id = project_id
        onboard_item.custom_argument_value = base.custom_argument_value
        onboard_item.last_updated_by_id = session[:user_id]
        begin
          onboard_item.save
        rescue => e
          flash[:notice] = 'Base#=' + base.id.to_s  + ',' + e.message
        end
      end unless params['single_id'].blank?
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
    end
  end
end
