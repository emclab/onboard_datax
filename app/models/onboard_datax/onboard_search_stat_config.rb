module OnboardDatax
  class OnboardSearchStatConfig < ActiveRecord::Base
    attr_accessor :config_desp, :brief_note, :engine_name, :labels_and_fields, :resource_name, :search_list_form, :search_params, :search_results_period_limit, 
                  :search_summary_function, :search_where, :stat_function, :stat_header, :stat_summary_function, :time_frame, :last_updated_by_name, :project_name
    attr_accessible :project_id, :search_stat_config_id, :custom_stat_header, :custom_search_summary_function, :custom_stat_summary_function,
                    :engine_id, :engine_name, :project_name, :brief_note, :config_desp, :engine_id, :labels_and_fields, :resource_name, :search_list_form, 
                    :search_params, :search_results_period_limit, :search_summary_function, :search_where, :stat_function, :stat_header, :stat_summary_function, 
                    :time_frame, :project_name,
                    :as => :role_new
    attr_accessible :last_updated_by_name, :custom_stat_header, :custom_search_summary_function, :brief_note, :config_desp, :engine_id, :labels_and_fields, 
                    :resource_name, :search_list_form, :search_params, :search_results_period_limit, :search_summary_function, :search_where, :stat_function, 
                    :stat_header, :stat_summary_function, :time_frame, :custom_stat_summary_function, :engine_name, :project_name,
                    :as => :role_update
    
    attr_accessor :start_date_s, :end_date_s, :resource_name_s, :engine_name_s, :config_desp_s, :project_id_s 

    attr_accessible :start_date_s, :end_date_s, :resource_name_s, :engine_name_s, :config_desp_s, :project_id_s,
                    :as => :role_search_stats
    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :search_stat_config, :class_name => OnboardDatax.search_stat_config_class.to_s  
    belongs_to :project, :class_name => OnboardDatax.project_class.to_s
    belongs_to :engine, :class_name => OnboardDatax.engine_class.to_s
    
    validates :project_id, :search_stat_config_id, :engine_id, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
    validates :search_stat_config_id, :uniqueness => {:scope => :project_id, :case_sensitive => false, :message => I18n.t('Duplicate Search/Stat Config')}
    
    #cnovert to csv
    def self.to_csv
      CSV.generate do |csv|
        #header array
        header = ['id', 'resource_name', 'stat_function', 'stat_summary_function', 'labels_and_fields', 'time_frame', 'search_list_form', 'search_where', 'search_results_period_limit', 
                  'last_updated_by_id', 'brief_note', 'created_at', 'updated_at',  'stat_header', 'search_params', 'search_summary_function']        
        csv << header
        all.each do |config|
          #assembly array for the row
          base = OnboardDatax.search_stat_config_class.find_by_id(config.attributes.values_at('search_stat_config_id')[0].to_i)
          row = Array.new
          row << config.attributes.values_at('id')[0]
          row << base.stat_function
          row << (config.attributes.values_at('custom_stat_summary_function')[0].present? ? config.attributes_values_at('custom_stat_summary_function')[0] : base.stat_summary_function)
          row << base.labels_and_fields
          row << base.time_frame
          row << base.search_list_form
          row << base.search_where
          row << base.search_results_period_limit
          row << config.attributes.values_at('last_updated_by_id')[0]
          row << base.brief_note
          row << config.attributes.values_at('created_at')[0]
          row << config.attributes.values_at('updated_at')[0]
          row << (config.attributes.values_at('custom_stat_header')[0].present? ? config.attributes_values_at('custom_stat_header')[0] : base.stat_header)
          row << base.search_params
          row << (config.attributes.values_at('custom_search_summary_function')[0].present? ? config.attributes_values_at('custom_search_summary_function')[0] : base.search_summary_function)
          #inject to csv
          csv << row
        end
      end
    end
  end
end
