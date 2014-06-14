require_dependency "onboard_datax/application_controller"

module OnboardDatax
  class OnboardSearchStatConfigsController < ApplicationController
    before_filter :require_employee
    before_filter :load_record
    
    def index
      @title = t('Onboard Search/Stat Configs')
      @onboard_search_stat_configs =  params[:onboard_datax_onboard_search_stat_configs][:model_ar_r]
      @onboard_search_stat_configs = @onboard_search_stat_configs.where('onboard_datax_onboard_search_stat_configs.project_id = ?', @project.id) if @project
      @onboard_search_stat_configs = @onboard_search_stat_configs.where('onboard_datax_onboard_search_stat_configs.engine_id = ?', @engine.id) if @engine
      @onboard_search_stat_configs = @onboard_search_stat_configs.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('onboard_search_stat_config_index_view', 'onboard_datax')
      #for csv download
      respond_to do |format|
        format.html
        format.csv { send_data @onboard_search_stat_configs.to_csv }
      end
    end

    def new
      @title = t('New Onboard Search/Stat Config')
      @onboard_search_stat_config = OnboardDatax::OnboardSearchStatConfig.new
      @erb_code = find_config_const('onboard_search_stat_config_new_view', 'onboard_datax')
    end


    def create
      @onboard_search_stat_config = OnboardDatax::OnboardSearchStatConfig.new(params[:onboard_search_stat_config], :as => :role_new)
      @onboard_search_stat_config.last_updated_by_id = session[:user_id]
      if @onboard_search_stat_config.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        flash[:notice] = t('Data Error. Not Saved!')
        @erb_code = find_config_const('onboard_search_stat_config_new_view', 'onboard_datax')
        render 'new'
      end
    end

    def edit
      @title = t('Edit Onboard Search/Stat Config')
      @onboard_search_stat_config = OnboardDatax::OnboardSearchStatConfig.find_by_id(params[:id])
      @erb_code = find_config_const('onboard_search_stat_config_edit_view', 'onboard_datax')
    end

    def update
        @onboard_search_stat_config = OnboardDatax::OnboardSearchStatConfig.find_by_id(params[:id])
        @onboard_search_stat_config.last_updated_by_id = session[:user_id]
        if @onboard_search_stat_config.update_attributes(params[:onboard_search_stat_config], :as => :role_update)
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
        else
          flash[:notice] = t('Data Error. Not Updated!')
          @search_stat_config = OnboardDatax.search_stat_config_class.find_by_id(params[:onboard_search_stat_config][:search_stat_config_id].to_i) if params[:onboard_search_stat_config][:search_stat_config_id].present?
          @project = OnboardDatax.project_class.find_by_id(params[:onboard_search_stat_config][:project_id]) if params[:onboard_search_stat_config][:project_id].present?
          @engine = OnboardDatax.engine_class.find_by_id(params[:onboard_search_stat_config][:engine_id].to_i) if params[:onboard_search_stat_config][:engine_id].present?
          @erb_code = find_config_const('onboard_search_stat_config_edit_view', 'onboard_datax')
          render 'edit'
        end
    end

    def show
      @title = t('Onboard Search/Stat Config Info')
      @onboard_search_stat_config = OnboardDatax::OnboardSearchStatConfig.find_by_id(params[:id])
      @search_stat_config = OnboardDatax.search_stat_config_class.find_by_id(@onboard_search_stat_config.search_stat_config_id)
      @erb_code = find_config_const('onboard_search_stat_config_show_view', 'onboard_datax')
    end
    
    def destroy  
      OnboardDatax::OnboardSearchStatConfig.delete(params[:id].to_i)
      redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Deleted!")
    end
    
    protected
    def load_record
      @search_stat_config = OnboardDatax.search_stat_config_class.find_by_id(params[:search_stat_config_id].to_i) if params[:search_stat_config_id].present?
      @search_stat_config = OnboardDatax.search_stat_config_class.find_by_id(OnboardDatax::OnboardSearchStatConfig.find_by_id(params[:id].to_i).search_stat_config_id) if params[:id].present?
      @project = OnboardDatax.project_class.find_by_id(params[:project_id]) if params[:project_id].present?
      @project = OnboardDatax.project_class.find_by_id(OnboardDatax::OnboardSearchStatConfig.find_by_id(params[:id]).project_id) if params[:id].present?      
      @engine = OnboardDatax.engine_class.find_by_id(params[:engine_id].to_i) if params[:engine_id].present?
      @engine = OnboardDatax.engine_class.find_by_id(OnboardDatax::OnboardSearchStatConfig.find_by_id(params[:id]).engine_id) if params[:id].present?
    end
  end
end
