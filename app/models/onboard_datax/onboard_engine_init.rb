module OnboardDatax
  class OnboardEngineInit < ActiveRecord::Base
    attr_accessor :file_name, :init_code, :init_desp, :project_name, :last_updated_by_name, :engine_name
    attr_accessible :engine_init_id, :project_id,  :engine_id, :engine_name, :project_name, :file_name, :init_code, :init_desp,
                    :as => :role_new
    attr_accessible :project_name, :last_updated_by_name, :engine_name, :file_name, :init_code, :init_desp,
                    :as => :role_update
    
    attr_accessor :start_date_s, :end_date_s, :file_name_s, :engine_id_s, :init_desp_s, :project_id_s

    attr_accessible :start_date_s, :end_date_s, :file_name_s, :engine_id_s, :init_desp_s, :project_id_s,
                    :as => :role_search_stats
    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :engine_init, :class_name => OnboardDatax.engine_init_class.to_s  
    belongs_to :project, :class_name => OnboardDatax.project_class.to_s
    belongs_to :engine, :class_name => OnboardDatax.engine_class.to_s
    
    validates :project_id, :engine_init_id, :engine_id, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
    validates :engine_init_id, :uniqueness => {:scope => :project_id, :case_sensitive => false, :message => I18n.t('Duplicate Config Init')}
  end
end
