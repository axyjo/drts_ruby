require 'spec_helper'

describe Unit do
  let(:unit) { Factory(:unit) }

  it "should be invalid without a name" do
    unit.valid?.should == false
    unit.name = 'Test Unit'
    unit.valid?.should == true
  end

  it "should be invalid without a type" do
    unit.valid?.should == false
    unit.type = 1
    unit.valid?.should == true
  end
end
