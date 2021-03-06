module OnboardDatax
  class OnboardUserAccess < ActiveRecord::Base
    attr_accessor :project_name, :role_definition_name, :access_desp, :action, :brief_note, :masked_attrs, :rank, :resource, :sql_code, :engine_name, :last_updated_by_name
    attr_accessible :project_id, :role_definition_id, :user_access_id, :project_name, :role_definition_name, :access_desp, :action, :brief_note, :masked_attrs, :rank, 
                    :resource, :sql_code, :engine_name, :engine_id, 
                    :as => :role_new
    attr_accessible :role_definition_id, :project_name, :role_definition_name, :access_desp, :action, :brief_note, :masked_attrs, :rank, :resource, :sql_code, 
                    :engine_name, :last_updated_by_name, :project_name,
                    :as => :role_update
                    
    attr_accessor :start_date_s, :end_date_s, :action_s, :resource_s, :access_desp_s, :engine_name_s, :project_id_s

    attr_accessible :start_date_s, :end_date_s, :action_s, :resource_s, :access_desp_s, :engine_name_s, :project_id_s,
                    :as => :role_search_stats 
    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :user_access, :class_name => OnboardDatax.user_access_class.to_s  
    belongs_to :project, :class_name => OnboardDatax.project_class.to_s
    belongs_to :engine, :class_name => OnboardDatax.engine_class.to_s
    belongs_to :role_definition, :class_name => OnboardDatax.project_misc_definition_class.to_s
    
    validates :project_id, :user_access_id, :engine_id, :role_definition_id, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
    validates :user_access_id, :uniqueness => {:scope => [:project_id, :role_definition_id], :case_sensitive => false, :message => I18n.t('Duplicate Access')}
    
    #cnovert to csv
    def self.to_csv
      CSV.generate do |csv|
        #header array
        header = ['id', 'action', 'resource', 'brief_note', 'last_updated_by_id', 'role_definition_id', 'sql_code', 'masked_attrs', 'rank', 'created_at', 'updated_at']        
        csv << header
        all.each do |config|
          #assembly array for the row
          base = OnboardDatax.user_access_class.find_by_id(config.attributes.values_at('user_access_id')[0].to_i)
          row = Array.new
          row << config.attributes.values_at('id')[0]
          row << base.action
          row << base.resource
          row << base.brief_note
          row << config.attributes.values_at('last_updated_by_id')[0]
          row << config.attributes.values_at('role_definition_id')[0]
          row << base.sql_code
          row << base.masked_attrs
          row << base.rank
          row << config.attributes.values_at('created_at')[0]
          row << config.attributes.values_at('updated_at')[0]
          #inject to csv
          csv << row
        end
      end
    end
  end
end
