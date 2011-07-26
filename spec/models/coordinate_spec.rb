require 'spec_helper'

describe Coordinate do
  it "generates the correct distance between two points - regular case" do
    coord1 = Coordinate.lnglat(1, 1)
    coord2 = Coordinate.lnglat(2, 2)
    coord1.distanceTo(coord2).should eq(Math.sqrt(2))
    coord2.distanceTo(coord1).should eq(Math.sqrt(2))
  end

  it "generates the correct distance between two points - toroidal lng case" do
    coord1 = Coordinate.lnglat(1, 1)
    coord2 = Coordinate.lnglat(128, 1)
    coord1.distanceTo(coord2).should eq(1)
    coord2.distanceTo(coord1).should eq(1)
  end

  it "generates the correct distance between two points - toroidal lat case" do
    coord1 = Coordinate.lnglat(1, 1)
    coord2 = Coordinate.lnglat(1, 128)
    coord1.distanceTo(coord2).should eq(1)
    coord2.distanceTo(coord1).should eq(1)
  end

  it "generates the correct distance between two points - toroidal diagonal case" do
    coord1 = Coordinate.lnglat(1, 1)
    coord2 = Coordinate.lnglat(128, 128)
    coord1.distanceTo(coord2).should eq(Math.sqrt(2))
    coord2.distanceTo(coord1).should eq(Math.sqrt(2))
  end

  it "generates the right neighbours when both coordinates are on the edge" do
    coord1 = Coordinate.lnglat(1, 1)
    coord1.north.lng.should eq(1)
    coord1.north.lat.should eq(128)
    coord1.south.lng.should eq(1)
    coord1.south.lat.should eq(2)
    coord1.west.lng.should eq(128)
    coord1.west.lat.should eq(1)
    coord1.east.lng.should eq(2)
    coord1.east.lat.should eq(1)
  end

  it "generates the right neighbours when one coordinate is on the edge" do
    coord2 = Coordinate.lnglat(128, 121)
    coord2.north.lng.should eq(128)
    coord2.north.lat.should eq(120)
    coord2.south.lng.should eq(128)
    coord2.south.lat.should eq(122)
    coord2.west.lng.should eq(127)
    coord2.west.lat.should eq(121)
    coord2.east.lng.should eq(1)
    coord2.east.lat.should eq(121)
  end

  it "generates the right neighbours when no coordinates are on the edge" do
    coord3 = Coordinate.lnglat(64, 64)
    coord3.north.lng.should eq(64)
    coord3.north.lat.should eq(63)
    coord3.south.lng.should eq(64)
    coord3.south.lat.should eq(65)
    coord3.west.lng.should eq(63)
    coord3.west.lat.should eq(64)
    coord3.east.lng.should eq(65)
    coord3.east.lat.should eq(64)
  end
end
