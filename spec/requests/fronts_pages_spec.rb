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
    let(:front) {FactoryGirl.build(:front) }

    before do
      visit fronts_path
      click_link "New Front"
    end

    describe "with invalid information" do

      before { click_button "Create" }

      it "should re-display the form" do
        expect(page).to have_selector "form#new_front"
      end

      it "should show error count" do
        @front = Front.new
        @front.save
        @error_count = @front.errors.count
        expect(page).to have_content("The form contains #{@error_count} errors")
      end

      it "should require required fields" do
        @front = Front.new
        @front.save
        @error_messages = @front.errors.full_messages

        @error_messages.each do |message|
          expect(page).to have_content(message)
        end
      end

    end


    describe "with valid information" do

      it "should create the Front" do
        fill_in "Market",    with: front.market
        fill_in "Segment",   with: front.segment
        fill_in "Site",      with: front.site
        fill_in "App layer", with: front.app_layer
        fill_in "Pipe",      with: front.pipe
        fill_in "Status",    with: front.status
        fill_in "Notes",     with: front.notes
        expect{click_button("Create")}.to change{Front.count}.by(1)
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
