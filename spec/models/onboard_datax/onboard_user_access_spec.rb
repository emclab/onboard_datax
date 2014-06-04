require 'spec_helper'

module OnboardDatax
  describe OnboardUserAccess do
    it "should be OK" do
      c = FactoryGirl.build(:onboard_datax_onboard_user_access)
      c.should be_valid
    end
    
    it "should reject 0 project id" do
      c = FactoryGirl.build(:onboard_datax_onboard_user_access, :project_id => 0)
      c.should_not be_valid
    end
    
    it "should reject 0 engine id" do
      c = FactoryGirl.build(:onboard_datax_onboard_user_access, :engine_id => 0)
      c.should_not be_valid
    end
    
    it "should reject 0 role id" do
      c = FactoryGirl.build(:onboard_datax_onboard_user_access, :role_definition_id => 0)
      c.should_not be_valid
    end
    
    it "should reject 0 user access id" do
      c = FactoryGirl.build(:onboard_datax_onboard_user_access, :user_access_id => 0)
      c.should_not be_valid
    end
    
    it "should reject dup user_access_id for one project & role id" do
      c1 = FactoryGirl.create(:onboard_datax_onboard_user_access)
      c = FactoryGirl.build(:onboard_datax_onboard_user_access, :project_id => c1.project_id)
      c.should_not be_valid
    end
  end
end
