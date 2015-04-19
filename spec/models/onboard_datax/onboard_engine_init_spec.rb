require 'spec_helper'

module OnboardDatax
  describe OnboardEngineInit do
    it "should be OK" do
      c = FactoryGirl.build(:onboard_datax_onboard_engine_init)
      c.should be_valid
    end
    
    it "should reject 0 project id" do
      c = FactoryGirl.build(:onboard_datax_onboard_engine_init, :project_id => 0)
      c.should_not be_valid
    end
    
    it "should reject 0 release id" do
      c = FactoryGirl.build(:onboard_datax_onboard_engine_init, :release_id => 0)
      c.should_not be_valid
    end
    
    it "should reject 0 engine id" do
      c = FactoryGirl.build(:onboard_datax_onboard_engine_init, :engine_id => 0)
      c.should_not be_valid
    end
    
    it "should reject 0 engine init id" do
      c = FactoryGirl.build(:onboard_datax_onboard_engine_init, :engine_init_id => 0)
      c.should_not be_valid
    end
    
    it "should reject dup engine_init_id for one project" do
      c1 = FactoryGirl.create(:onboard_datax_onboard_engine_init)
      c = FactoryGirl.build(:onboard_datax_onboard_engine_init, :project_id => c1.project_id)
      c.should_not be_valid
    end
  end
end
