require 'spec_helper'

describe "UserRegistrations" do
  it "lets users access the page" do
    get sign_up_path
    response.status.should be(200)
  end

  it "allows users fill the form" do
    visit sign_up_path
    fill_in "Username", :with => "test"
    fill_in "Email", :with => "test@example.com"
    fill_in "Password", :with => "password"
    fill_in "Password confirmation", :with => "password"
    click_button "Create account"
    current_path.should eq(root_path)
  end

  it "checks for invalid form data" do
    visit sign_up_path
    fill_in "Username", :with => "test"
    click_button "Create account"
    page.should have_content("Email can't be blank")
    page.should have_content("Password can't be blank")

    visit sign_up_path
    fill_in "Email", :with => "test"
    click_button "Create account"
    page.should have_content("Username can't be blank")
    page.should have_content("Password can't be blank")

    visit sign_up_path
    fill_in "Password", :with => "password"
    fill_in "Password confirmation", :with => "password2"
    click_button "Create account"
    page.should have_content("Password doesn't match")
  end

  it "sends users an email after registering" do

  end
end
