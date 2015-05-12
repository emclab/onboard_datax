module OnboardDatax
  class OnboardSearchStatConfig < ActiveRecord::Base
    attr_accessor :config_desp, :brief_note, :engine_name, :labels_and_fields, :resource_name, :search_list_form, :search_params, :search_results_period_limit, 
                  :search_summary_function, :search_where, :stat_function, :stat_header, :stat_summary_function, :time_frame, :last_updated_by_name, :project_name,
                  :release_name
    attr_accessible :project_id, :search_stat_config_id, :custom_stat_header, :custom_search_summary_function, :custom_stat_summary_function, :release_id,
                    :engine_id, :engine_name, :project_name, :brief_note, :config_desp, :engine_id, :labels_and_fields, :resource_name, :search_list_form, 
                    :search_params, :search_results_period_limit, :search_summary_function, :search_where, :stat_function, :stat_header, :stat_summary_function, 
                    :time_frame, :project_name, :custom_stat_function, :custom_search_results_period_limit, :custom_time_frame, :custom_labels_and_fields,
                    :as => :role_new
    attr_accessible :last_updated_by_name, :custom_stat_header, :custom_search_summary_function, :brief_note, :config_desp, :engine_id, :labels_and_fields, :release_id, 
                    :resource_name, :search_list_form, :search_params, :search_results_period_limit, :search_summary_function, :search_where, :stat_function, 
                    :stat_header, :stat_summary_function, :time_frame, :custom_stat_summary_function, :engine_name, :project_name,
                    :custom_stat_function, :custom_search_results_period_limit, :custom_time_frame, :custom_labels_and_fields,
                    :as => :role_update
    
    attr_accessor :start_date_s, :end_date_s, :resource_name_s, :engine_id_s, :config_desp_s, :project_id_s, :custom_code_s, :release_id_s

    attr_accessible :start_date_s, :end_date_s, :resource_name_s, :engine_id_s, :config_desp_s, :project_id_s, :custom_code_s, :release_id_s,
                    :as => :role_search_stats
    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :search_stat_config, :class_name => OnboardDatax.search_stat_config_class.to_s  
    belongs_to :project, :class_name => OnboardDatax.project_class.to_s
    belongs_to :engine, :class_name => OnboardDatax.engine_class.to_s
    belongs_to :release, :class_name => OnboardDatax.project_misc_definition_class.to_s
    
    validates :project_id, :search_stat_config_id, :engine_id, :release_id, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
    validates :search_stat_config_id, :uniqueness => {:scope => [:project_id, :release_id], :case_sensitive => false, :message => I18n.t('Duplicate Search/Stat Config')}
    
    #cnovert to csv
    def self.to_csv
      CSV.generate do |csv|
        #header array
        header = ['id', 'resource_name', 'stat_function', 'stat_summary_function', 'labels_and_fields', 'time_frame', 'search_list_form', 'search_where', 'search_results_period_limit', 
                  'last_updated_by_id', 'brief_note', 'created_at', 'updated_at',  'stat_header', 'search_params', 'search_summary_function']        
        csv << header
        i = 1
        all.each do |config|
          #assembly array for the row
          base = OnboardDatax.search_stat_config_class.find_by_id(config.search_stat_config_id)
          row = Array.new
          row << i
          row << base.resource_name
          row << (config.custom_stat_function.present? ? config.custom_stat_function : base.stat_function)
          row << (config.custom_stat_summary_function.present? ? config.custom_stat_summary_function : base.stat_summary_function)
          row << (config.custom_labels_and_fields.present? ? config.custom_labels_and_fields : base.labels_and_fields)
          row << (config.custom_time_frame.present? ? config.custom_time_frame : base.time_frame)
          row << base.search_list_form
          row << base.search_where
          row << (config.custom_search_results_period_limit.present? ? config.custom_search_results_period_limit : base.search_results_period_limit)
          row << config.last_updated_by_id
          row << base.brief_note
          row << config.created_at
          row << config.updated_at
          row << (config.custom_stat_header.present? ? config.custom_stat_header : base.stat_header)
          row << base.search_params
          row << (config.custom_search_summary_function.present? ? config.custom_search_summary_function : base.search_summary_function)
          #inject to csv
          csv << row
          i += 1
        end
      end
    end
  end
end
