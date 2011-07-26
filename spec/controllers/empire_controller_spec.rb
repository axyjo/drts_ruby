require 'spec_helper'

describe EmpireController do

  describe "GET 'list'" do
    it "should be successful" do
      get 'list'
      response.should be_success
    end
  end

  describe "GET 'choose'" do
    it "should be successful" do
      get 'choose'
      response.should be_success
    end
  end

end
