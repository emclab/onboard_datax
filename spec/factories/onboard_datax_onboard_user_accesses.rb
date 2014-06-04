# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :onboard_datax_onboard_user_access, :class => 'OnboardDatax::OnboardUserAccess' do
    project_id 1
    #last_updated_by_id 1
    role_definition_id 1
    user_access_id 1
    engine_id 1
  end
end
