require 'spec_helper'

describe "UserRegistrations" do
  it "lets users access the page" do
    get sign_up_path
    response.status.should be(200)
  end

  it "allows users fill the form" do

  end

  it "sends users an email after registering" do

  end
end
