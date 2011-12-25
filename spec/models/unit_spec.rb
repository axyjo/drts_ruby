require 'spec_helper'

describe Unit do
  let(:unit) { Factory.build(:unit) }

  it "should be invalid without a name" do
    unit.name = nil
    unit.valid?.should be_false
    unit.name = 'Test Unit'
    unit.valid?.should be_true
  end

  it "should be invalid without a type" do
    unit.type = nil
    unit.valid?.should be_false
    unit.type = 1
    unit.valid?.should be_true
  end

  it "should correctly report if it is a land unit" do
    unit.type = 1
    unit.is_land?.should be_true
    unit.is_water?.should be_false
  end

  it "should correctly report if it is a water unit" do
    unit.type = 2
    unit.is_land?.should be_false
    unit.is_water?.should be_true
  end
end
