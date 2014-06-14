module OnboardDatax
  class OnboardEngineConfig < ActiveRecord::Base
    attr_accessor :project_name, :argument_name, :argument_desp, :brief_note, :argument_value, :global, :engine_version, :last_updated_by_name, :engine_name
    attr_accessible :engine_config_id, :project_id, :custom_argument_value, :project_name, :argument_name, :argument_desp, :brief_note, :argument_value, 
                    :global, :engine_version, :engine_id, :engine_name,
                    :as => :role_new
    attr_accessible :custom_argument_value, :project_name, :argument_name, :argument_desp, :brief_note, :argument_value, :global, 
                    :engine_version, :last_updated_by_name, :engine_name, 
                    :as => :role_update
    
    attr_accessor :start_date_s, :end_date_s, :argument_name_s, :engine_id_s, :argument_desp_s, :commissioned_by_id_s, :project_id_s

    attr_accessible :start_date_s, :end_date_s, :argument_name_s, :engine_id_s, :argument_desp_s, :commissioned_by_id_s, :project_id_s,
                    :as => :role_search_stats
                    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :engine_config, :class_name => OnboardDatax.engine_config_class.to_s  
    belongs_to :project, :class_name => OnboardDatax.project_class.to_s
    belongs_to :engine, :class_name => OnboardDatax.engine_class.to_s
    
    validates :project_id, :engine_config_id, :engine_id, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
    validates :engine_config_id, :uniqueness => {:scope => :project_id, :case_sensitive => false, :message => I18n.t('Duplicate Config')}
    
    #cnovert to csv
    def self.to_csv
      CSV.generate do |csv|
        #header array
        header = ['id', 'engine_name', 'engine_version', 'argument_name', 'argument_value', 'last_updated_by_id', 'created_at', 'updated_at', 'brief_note', 'global']        
        csv << header
        i = 1
        all.each do |config|
          #assembly array for the row
          base = OnboardDatax.engine_config_class.find_by_id(config.engine_config_id)
          row = Array.new
          row << i
          row << (base.global ? nil : base.engine.name)
          row << base.engine_version
          row << base.argument_name
          row << (config.custom_argument_value.present? ? config.custom_argument_value : base.argument_value)
          row << config.last_updated_by_id
          row << config.created_at
          row << config.updated_at
          row << base.brief_note
          row << (base.global ? 't' : 'f')
          #inject to csv
          csv << row
          i += 1
        end
      end
    end
    
  end
end
