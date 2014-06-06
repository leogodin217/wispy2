require 'rails_helper'

describe "Front pages" do
  subject { page }

  describe "showing a front" do
    let!(:front) {FactoryGirl.create(:front) }

    before {visit front_path(front.id) }

    it { should have_selector "li", text: front.full_name }
    it { should have_selector "li", text: front.market }
    it { should have_selector "li", text: front.segment }
    it { should have_selector "li", text: front.site }
    it { should have_selector "li", text: front.app_layer }
    it { should have_selector "li", text: front.status }
    it { should have_selector "li", text: front.notes }
    it { should have_link "Edit", href: edit_front_path(front.id) }
    it { should have_selector "a[href='#{front_path(front.id)}'][data-method='delete']" }
  end

  describe "listing fronts" do
    before do
      3.times do 
        FactoryGirl.create(:front)
      end

      visit fronts_path
    end
    let(:fronts) { Front.all }

    it { should have_link "New Front", new_front_path }

    it "should show all fronts" do
      fronts.each do |current_front|
        expect(page).to have_selector "tr", text: current_front.full_name  
      end
    end

    it "should have show links" do
      fronts.each do |current_front|
        expect(page).to have_link "Show", front_path(current_front)
      end       
    end


  end

  describe "creating a front" do
    let(:front_attributes) { {market:   "Market 1",
                             segment:   "Segment 1",
                             site:      "Site 1",
                             app_layer: "App layer 1",
                             status:    "Status 1",
                             notes:     "Notes 1" } }

    describe "Filling in the form" do
      before do
        visit fronts_path
        click_link "New Front"
      end  

      it "should create the Front" do
        fill_in("Market", with: front_attributes[:market])
        fill_in "Segment", with: front_attributes[:segment]
        fill_in "Site", with: front_attributes[:site]
        fill_in "Application layer", with: front_attributes[:app_layer]
        fill_in "Status", with: front_attributes[:status]
        fill_in "Notes", with: front_attributes[:notes]
        expect(click_link("Create")).to change(Front.count.by(1))
      end
    end
  end

  describe "deleting a front" do
    pending
  end

  describe "editing a front" do
    pending
  end
end