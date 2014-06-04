require 'spec_helper'

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
    pending
  end

  describe "deleting a front" do
    pending
  end

  describe "editing a front" do
    pending
  end
end