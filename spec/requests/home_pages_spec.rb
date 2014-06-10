require 'rails_helper'

describe "Home page" do
  subject { page }

  before { visit root_path }

    it { should have_title("Wispy Cloud Capacity") }
    it { should have_link "Sign in", signin_path }
    it { should have_link "Home", root_path }
end
