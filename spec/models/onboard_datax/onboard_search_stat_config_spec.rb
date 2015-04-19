require 'spec_helper'

module OnboardDatax
  describe OnboardSearchStatConfig do
    it "should be OK" do
      c = FactoryGirl.build(:onboard_datax_onboard_search_stat_config)
      c.should be_valid
    end
    
    it "should reject 0 project id" do
      c = FactoryGirl.build(:onboard_datax_onboard_search_stat_config, :project_id => 0)
      c.should_not be_valid
    end
    
    it "should reject 0 release id" do
      c = FactoryGirl.build(:onboard_datax_onboard_search_stat_config, :release_id => 0)
      c.should_not be_valid
    end
    
    it "should reject 0 engine id" do
      c = FactoryGirl.build(:onboard_datax_onboard_search_stat_config, :engine_id => 0)
      c.should_not be_valid
    end
    
    it "should reject 0 search stat config id" do
      c = FactoryGirl.build(:onboard_datax_onboard_search_stat_config, :search_stat_config_id => 0)
      c.should_not be_valid
    end
    
    it "should reject dup engine_config_id for one project" do
      c1 = FactoryGirl.create(:onboard_datax_onboard_search_stat_config)
      c = FactoryGirl.build(:onboard_datax_onboard_search_stat_config, :project_id => c1.project_id)
      c.should_not be_valid
    end
  end
end
