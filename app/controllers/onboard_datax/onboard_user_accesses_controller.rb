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
      @onboard_user_accesses = @onboard_user_accesses.where('onboard_datax_onboard_user_accesses.release_id = ?', @release.id) if @release
      @erb_code = find_config_const('onboard_user_access_index_view', 'onboard_datax')
      @engine_boarded = engine_boarded(@onboard_user_accesses)
      #for csv download
      respond_to do |format|
        format.html {@onboard_user_accesses = @onboard_user_accesses.page(params[:page]).per_page(@max_pagination)}
        format.csv do
          send_data @onboard_user_accesses.to_csv
          @csv = true
        end #if @release
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
    
    def copy
      @title = t('Copy from Another Project')
      @from_projects = OnboardDatax.project_class.order('id DESC')
      @from_project_array = @from_projects.select('id, name').map{|r| [r.name, r.id]}
      engine_ids = eval(OnboardDatax.engine_ids_belong_to_a_project) #if @project_id #engine_id
      @engines = OnboardDatax.engine_class.where(active: true).where(:id => engine_ids).order('name')
      @to_role_array = OnboardDatax.project_misc_definition_class.where('definition_category = ? AND project_id = ?', 'role_definition', @project.id).select('id, name').map{|r| [r.name, r.id]}
      @to_release = OnboardDatax.project_misc_definition_class.where(definition_category: 'release').where(project_id: @project.id).select('id, name').map{|r| [r.name, r.id]}
      @erb_code = find_config_const('onboard_user_access_copy_view', 'onboard_datax')
      @js_erb_code = find_config_const('onboard_user_access_copy_view_field', 'onboard_datax')
    end
    
    def copy_results
      to_project_id = params[:save].keys[0].to_i #to
      from_project_id = params[:pid_from].to_i if params[:pid_from].present?
      role_from_id = params[:rid_from].to_i if params[:rid_from].present?
      release_from = params[:release_from].to_i if params[:release_from]
      release_to = params[:release_to].to_i if params[:release_to]
      role_to_id = params[:rid_to].to_i if params[:rid_to].present?
      params['ids'].each do |eid|
        OnboardDatax::OnboardUserAccess.where('onboard_datax_onboard_user_accesses.project_id = ? AND role_definition_id = ? AND onboard_datax_onboard_user_accesses.engine_id = ? AND release_id = ?', 
                                              from_project_id, role_from_id, eid, release_from).each do |base|
          onboard_item = OnboardDatax::OnboardUserAccess.new
          onboard_item.user_access_id = base.user_access_id
          onboard_item.engine_id = eid
          onboard_item.project_id = to_project_id
          onboard_item.role_definition_id = role_to_id
          onboard_item.last_updated_by_id = session[:user_id]
          onboard_item.release_id = release_to
          begin
            onboard_item.save
          rescue => e
            flash[:notice] = 'Base#=' + base.id.to_s  + ',' + e.message
          end
        end
      end if params['ids'].present? && to_project_id && from_project_id && role_from_id && role_to_id  && release_from && release_to
      redirect_to  SUBURI + "/view_handler?index=1&url=#{onboard_user_accesses_path(project_id: to_project_id)}"
    end
    
    def batch_delete
      @title = t('Copy from Another Project')
      @roles = OnboardDataUploadx.project_misc_definition_class.where(:project_id => @project_id).where(:definition_category => 'role_definition').order('ranking_index')
      engine_ids = eval(OnboardDatax.engine_ids_belong_to_a_project) #if @project_id #engine_id
      @engines = OnboardDatax.engine_class.where(active: true).where(:id => engine_ids).order('name')
      @from_role_array = OnboardDatax.project_misc_definition_class.where('definition_category = ? AND project_id = ?', 'role_definition', @project.id).select('id, name').map{|r| [r.name, r.id]}
      @from_release = OnboardDatax.project_misc_definition_class.where(definition_category: 'release').where(project_id: @project.id).select('id, name').map{|r| [r.name, r.id]}
      @erb_code = find_config_const('onboard_user_access_batch_delete_view', 'onboard_datax')
      @js_erb_code = find_config_const('onboard_user_access_batch_delete_view_field', 'onboard_datax')
    end
    
    def batch_delete_result
      project_id = params[:save].keys[0].to_i #to
      role_id = params[:from_rid].to_i if params[:from_rid].present?
      release_id = params[:from_release].to_i if params[:from_release]
      params['ids'].each do |eid|
      OnboardDatax::OnboardUserAccess.where('onboard_datax_onboard_user_accesses.project_id = ? AND role_definition_id = ? AND onboard_datax_onboard_user_accesses.engine_id = ? AND release_id = ?', 
                                              project_id, role_id, eid, release_id).each do |base|
          begin
            OnboardDatax::OnboardUserAccess.delete(base.id)
          rescue => e
            flash[:notice] = 'Base#=' + base.id.to_s  + ',' + e.message
          end
        end
      end if params['ids'].present? && to_project_id && from_project_id && role_from_id && role_to_id  && release_from && release_to
      redirect_to  SUBURI + "/view_handler?index=1&url=#{onboard_user_accesses_path(project_id: to_project_id)}&msg=Successfully Deleted!"
    end
    
    protected
    def load_record
      @user_access = OnboardDatax.user_access_class.find_by_id(params[:user_access_id].to_i) if params[:user_access_id].present?
      @user_access = OnboardDatax.user_access_class.find_by_id(OnboardDatax::OnboardUserAccess.find_by_id(params[:id].to_i).user_access_id) if params[:id].present?
      @project = OnboardDatax.project_class.find_by_id(params[:project_id]) if params[:project_id].present?
      @project = OnboardDatax.project_class.find_by_id(OnboardDatax::OnboardUserAccess.find_by_id(params[:id]).project_id) if params[:id].present?      
      @engine = OnboardDatax.engine_class.find_by_id(params[:engine_id].to_i) if params[:engine_id].present?
      @engine = OnboardDatax.engine_class.find_by_id(OnboardDatax::OnboardUserAccess.find_by_id(params[:id]).engine_id) if params[:id].present?
      @release = OnboardDatax.project_misc_definition_class.find_by_id(params[:release_id].to_i) if params[:release_id].present?
      @release = OnboardDatax.project_misc_definition_class.find_by_id(params[:from_release].to_i) if params[:from_release].present?  #csv download
      @release = OnboardDatax.project_misc_definition_class.find_by_id(OnboardDatax::OnboardUserAccess.find_by_id(params[:id]).release_id) if params[:id].present?
    end
=begin
    def project_option_array(obj)
      p_array = [[]]
      obj.each do |p|
        p_array << [p.name, p.id]
      end
      return p_array
    end
    
    def role_option_array(obj)
      r_array = [[]]
      obj.each do |r|
        r_array << [r.name, r.id]
      end
      return r_array
    end
=end
    
  end
end
