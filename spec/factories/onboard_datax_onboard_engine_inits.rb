# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :onboard_datax_onboard_engine_init, :class => 'OnboardDatax::OnboardEngineInit' do
    project_id 1
    #last_updated_by_id 1
    engine_init_id 1
    engine_id 1
    release_id 2
  end
end
