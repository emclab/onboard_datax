require "onboard_datax/engine"

module OnboardDatax
  mattr_accessor :project_class, :engine_config_class, :user_access_class, :engine_init_class, :search_stat_config_class, :class_class, :engine_class, :customer_class,
                 :project_misc_definition_class, :engine_ids_belong_to_a_project
  
  def self.project_class
    @@project_class.constantize
  end
  
  def self.engine_config_class
    @@engine_config_class.constantize
  end
  
  def self.user_access_class
    @@user_access_class.constantize
  end
  
  def self.engine_init_class
    @@engine_init_class.constantize
  end
  
  def self.search_stat_config_class
    @@search_stat_config_class.constantize
  end
  
  def self.engine_class
    @@engine_class.constantize
  end
  
  def self.customer_class
    @@customer_class.constantize
  end
  
  def self.project_misc_definition_class
    @@project_misc_definition_class.constantize
  end
end
