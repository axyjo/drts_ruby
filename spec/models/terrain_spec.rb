require 'spec_helper'

describe Terrain do
  it "checks whether a new terrain can be created" do
    t = Terrain.new(name: "Test Terrain", blue_value: 254)
    t.name.should eq("Test Terrain")
    t.blue_value.should eq(254)
  end

  it "checks for the presence of a name" do
    t = Terrain.new(blue_value: 200)
    t.valid?.should be_false
  end

  it "checks the validity of blue_value" do
    t = Terrain.new(name: "test", blue_value: -1)
    t.valid?.should be_false

    t = Terrain.new(name: "test", blue_value: 256)
    t.valid?.should be_false

    t = Terrain.new(name: "test", blue_value: 12.3)
    t.valid?.should be_false

    t = Terrain.new(name: "test", blue_value: "alfalfa")
    t.valid?.should be_false
  end
end
