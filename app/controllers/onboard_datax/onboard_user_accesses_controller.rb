require_dependency "onboard_datax/application_controller"

module OnboardDatax
  class OnboardUserAccessesController < ApplicationController
    before_filter :require_employee
    before_filter :load_record
    
    def index
      @title = t('Onboard User Accesses')
      @onboard_user_accesses =  params[:onboard_datax_onboard_user_accesses][:model_ar_r]
      @onboard_user_accesses = @onboard_user_accesses.where('onboard_datax_onboard_user_accesses.project_id = ?', @project.id) if @project
      @onboard_user_accesses = @onboard_user_accesses.where('onboard_datax_onboard_user_accesses.engine_id = ?', @engine.id) if @engine
      @erb_code = find_config_const('onboard_user_access_index_view', 'onboard_datax')
      #for csv download
      respond_to do |format|
        format.html {@onboard_user_accesses = @onboard_user_accesses.page(params[:page]).per_page(@max_pagination)}
        format.csv do
          send_data @onboard_user_accesses.to_csv
          @csv = true
        end
      end
    end

    def new
      @title = t('New Onboard User Access')
      @onboard_user_access = OnboardDatax::OnboardUserAccess.new
      @erb_code = find_config_const('onboard_user_access_new_view', 'onboard_datax')
    end


    def create
      @onboard_user_access = OnboardDatax::OnboardUserAccess.new(params[:onboard_user_access], :as => :role_new)
      @onboard_user_access.last_updated_by_id = session[:user_id]
      if @onboard_user_access.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        flash[:notice] = t('Data Error. Not Saved!')
        @user_access = OnboardDatax.user_access_class.find_by_id(params[:onboard_user_access][:user_access_id].to_i) if params[:onboard_user_access][:user_access_id].present?
        @project = OnboardDatax.project_class.find_by_id(params[:onboard_user_access][:project_id]) if params[:onboard_user_access][:project_id].present?
        @engine = OnboardDatax.engine_class.find_by_id(params[:onboard_user_access][:engine_id].to_i) if params[:onboard_user_access][:engine_id].present?
        @role_definitions = Authentify::RoleDefinition.scoped.order('id')
        @erb_code = find_config_const('onboard_user_access_new_view', 'onboard_datax')
        render 'new'
      end
    end

    def edit
      @title = t('Edit Onboard User Access')
      @onboard_user_access = OnboardDatax::OnboardUserAccess.find_by_id(params[:id])
      @erb_code = find_config_const('onboard_user_access_edit_view', 'onboard_datax')
    end

    def update
        @onboard_user_access = OnboardDatax::OnboardUserAccess.find_by_id(params[:id])
        @onboard_user_access.last_updated_by_id = session[:user_id]
        @role_definitions = OnboardDatax.project_misc_definition_class.scoped.order('ranking_index')
      if @onboard_user_access.update_attributes(params[:onboard_user_access], :as => :role_update)
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
        else
          flash[:notice] = t('Data Error. Not Updated!')
          @erb_code = find_config_const('onboard_user_access_edit_view', 'onboard_datax')
          render 'edit'
        end
    end

    def show
      @title = t('Onboard User Access Info')
      @onboard_user_access = OnboardDatax::OnboardUserAccess.find_by_id(params[:id])
      @user_access = OnboardDatax.user_access_class.find_by_id(@onboard_user_access.user_access_id)
      @erb_code = find_config_const('onboard_user_access_show_view', 'onboard_datax')
    end
    
    def destroy  
      OnboardDatax::OnboardUserAccess.delete(params[:id].to_i)
      redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Deleted!")
    end
    
    protected
    def load_record
      @user_access = OnboardDatax.user_access_class.find_by_id(params[:user_access_id].to_i) if params[:user_access_id].present?
      @user_access = OnboardDatax.user_access_class.find_by_id(OnboardDatax::OnboardUserAccess.find_by_id(params[:id].to_i)) if params[:id].present?
      @project = OnboardDatax.project_class.find_by_id(params[:project_id]) if params[:project_id].present?
      @project = OnboardDatax.project_class.find_by_id(OnboardDatax::OnboardUserAccess.find_by_id(params[:id]).project_id) if params[:id].present?      
      @engine = OnboardDatax.engine_class.find_by_id(params[:engine_id].to_i) if params[:engine_id].present?
      @engine = OnboardDatax.engine_class.find_by_id(OnboardDatax::OnboardUserAccess.find_by_id(params[:id]).engine_id) if params[:id].present?
    end
  end
end
