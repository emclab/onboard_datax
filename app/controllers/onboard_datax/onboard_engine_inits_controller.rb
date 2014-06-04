require_dependency "onboard_datax/application_controller"

module OnboardDatax
  class OnboardEngineInitsController < ApplicationController
    before_filter :require_employee
    before_filter :load_record
    
    def index
      @title = t('Onboard Engine Inits')
      @onboard_engine_inits =  params[:onboard_datax_onboard_engine_inits][:model_ar_r]
      @onboard_engine_inits = @onboard_engine_inits.where('onboard_datax_onboard_engine_inits.project_id = ?', @project.id) if @project
      @onboard_engine_inits = @onboard_engine_inits.where('onboard_datax_onboard_engine_inits.engine_id = ?', @engine.id) if @engine
      @onboard_engine_inits = @onboard_engine_inits.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('onboard_engine_init_index_view', 'onboard_datax')
    end

    def new
      @title = t('New Onboard Engine Init')
      @onboard_engine_init = OnboardDatax::OnboardEngineInit.new
      @erb_code = find_config_const('onboard_engine_init_new_view', 'onboard_datax')
    end


    def create
      @onboard_engine_init = OnboardDatax::OnboardEngineInit.new(params[:onboard_engine_init], :as => :role_new)
      @onboard_engine_init.last_updated_by_id = session[:user_id]
      if @onboard_engine_init.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        flash[:notice] = t('Data Error. Not Saved!')
        @engine_init = OnboardDatax.engine_init_class.find_by_id(params[:onboard_engine_init][:engine_init_id].to_i) if params[:onboard_engine_init][:engine_init_id].present?
        @project = OnboardDatax.project_class.find_by_id(params[:onboard_engine_init][:project_id]) if params[:onboard_engine_init][:project_id].present?
        @engine = OnboardDatax.engine_class.find_by_id(params[:onboard_engine_init][:engine_id].to_i) if params[:onboard_engine_init][:engine_id].present?
        @erb_code = find_config_const('onboard_engine_init_new_view', 'onboard_datax')
        render 'new'
      end
    end

    def edit
      @title = t('Edit Onboard Engine Init')
      @onboard_engine_init = OnboardDatax::OnboardEngineInit.find_by_id(params[:id])
      @erb_code = find_config_const('onboard_engine_init_edit_view', 'onboard_datax')
    end

    def update
        @onboard_engine_init = OnboardDatax::OnboardEngineInit.find_by_id(params[:id])
        @onboard_engine_init.last_updated_by_id = session[:user_id]
        if @onboard_engine_init.update_attributes(params[:onboard_engine_init], :as => :role_update)
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
        else
          flash[:notice] = t('Data Error. Not Updated!')
          @erb_code = find_config_const('onboard_engine_init_edit_view', 'onboard_datax')
          render 'edit'
        end
    end

    def show
      @title = t('Onboard Engine Init Info')
      @onboard_engine_init = OnboardDatax::OnboardEngineInit.find_by_id(params[:id])
      @engine_init = OnboardDatax.engine_init_class.find_by_id(@onboard_engine_init.engine_init_id)
      @erb_code = find_config_const('onboard_engine_init_show_view', 'onboard_datax')
    end
    
    def destroy  
      OnboardDatax::OnboardEngineInit.delete(params[:id].to_i)
      redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Deleted!")
    end
    
    protected
    def load_record
      @engine_init = OnboardDatax.engine_init_class.find_by_id(params[:engine_init_id].to_i) if params[:engine_init_id].present?
      @engine_init = OnboardDatax.engine_init_class.find_by_id(OnboardDatax::OnboardEngineInit.find_by_id(params[:id].to_i)) if params[:id].present?
      @project = OnboardDatax.project_class.find_by_id(params[:project_id]) if params[:project_id].present?
      @project = OnboardDatax.project_class.find_by_id(OnboardDatax::OnboardEngineInit.find_by_id(params[:id]).project_id) if params[:id].present?      
      @engine = OnboardDatax.engine_class.find_by_id(params[:engine_id].to_i) if params[:engine_id].present?
      @engine = OnboardDatax.engine_class.find_by_id(OnboardDatax::OnboardEngineInit.find_by_id(params[:id]).engine_id) if params[:id].present?
    end
  end
end
