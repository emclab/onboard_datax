OnboardDatax.customer_class = 'Kustomerx::Customer'
OnboardDatax.project_class = 'InfoServiceProjectx::Project'
OnboardDatax.engine_config_class = 'OnboardDataUploadx::EngineConfig'
OnboardDatax.user_access_class = 'OnboardDataUploadx::UserAccess'
OnboardDatax.engine_init_class = 'OnboardDataUploadx::EngineInit'
OnboardDatax.search_stat_config_class = 'OnboardDataUploadx::SearchStatConfig'
OnboardDatax.engine_class = 'SwModuleInfox::ModuleInfo'
OnboardDatax.project_misc_definition_class = 'ProjectMiscDefinitionx::MiscDefinition'
OnboardDatax.engine_ids_belong_to_a_project = "ResourceAllocx::Allocation.where(:active => true, :resource_id => @project.id, :resource_string => 'info_service_projectx/projects').pluck('detailed_resource_id')"

