require 'rails_helper'

describe "admin index" do
  subject { page  }
  before { visit admin_path }

  it { should have_link "Fronts",     fronts_path }
  it { should have_link "Markets",    markets_path }
  it { should have_link "Segments",   segments_path }
  it { should have_link "Sites",      sites_path }
  it { should have_link "App layers", app_layers_path }
  it { should have_link "Pipes",      pipes_path }
  it { should have_link "Statuses",   statuses_path }
end
