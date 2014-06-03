require 'rails_helper'

describe "Home page" do
  subject { page }

  before { visit root_path }

    it { should have_selector("h1", text: "Wispy Cloud Capacity") }
    it { should have_title("Wispy Cloud Capacity") }
end