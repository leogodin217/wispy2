require 'rails_helper'

describe "Front pages" do
  subject { page }

  describe "showing a front" do
    let!(:front) {FactoryGirl.create(:front) }

    before {visit front_path(front.id) }

    it { should have_selector "dl>dd", text: front.full_name }
    it { should have_selector "dl>dd", text: front.market }
    it { should have_selector "dl>dd", text: front.segment }
    it { should have_selector "dl>dd", text: front.site }
    it { should have_selector "dl>dd", text: front.app_layer }
    it { should have_selector "dl>dd", text: front.status }
    it { should have_selector "dl>dd", text: front.notes }
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

    before do
      visit fronts_path
      click_link "New Front"
    end

    describe "with invalid information" do
    let(:front) {FactoryGirl.build(:front) }

      before do
        visit new_front_path
        click_button "Submit"
      end

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
      let(:front) { FactoryGirl.build(:front) }

      before do
        # Create the menus
        FactoryGirl.create(:market, market: front.market)
        FactoryGirl.create(:segment, segment: front.segment)
        FactoryGirl.create(:site, site: front.site)
        FactoryGirl.create(:app_layer, app_layer: front.app_layer)
        FactoryGirl.create(:pipe, pipe: front.pipe)
        FactoryGirl.create(:status, status: front.status)
        visit new_front_path

        select front.market,    from: "Market"
        select front.segment,   from: "Segment"
        select front.site,      from: "Site"
        select front.app_layer, from: "App layer"
        select front.pipe,      from: "Pipe"
        select front.status,    from: "Status"
        fill_in "Notes",        with: front.notes
      end

      it "should create the Front" do
        expect{click_button("Submit")}.to change{Front.count}.by(1)
      end

      it "should flash a success message" do
        click_button("Submit")
        expect(page).to have_content "Front successfully created"
      end
    end

  end

  describe "deleting a front" do
    let!(:front) { FactoryGirl.create(:front) }

    before do
      visit front_path(front.id)
    end

    it "should delete the front" do
      expect{click_link("Delete")}.to change{Front.count}.by(-1)
    end

    it "should flash a success message" do
      click_link "Delete"
      expect(page).to have_content "Front successfuly destroyed."
    end

    it "should redirect to the fronts index" do
      click_link "Delete"
      expect(page.current_url).to eq fronts_url
    end

  end

  describe "editing a front" do
    let!(:valid_front)   { FactoryGirl.create(:front) }
    let!(:changed_front) { FactoryGirl.build(:front) }

    before do
      # Create menus for both fronts
      FactoryGirl.create(:market,    market:    changed_front.market)
      FactoryGirl.create(:segment,   segment:   changed_front.segment)
      FactoryGirl.create(:site,      site:      changed_front.site)
      FactoryGirl.create(:app_layer, app_layer: changed_front.app_layer)
      FactoryGirl.create(:pipe,      pipe:      changed_front.pipe)
      FactoryGirl.create(:status,    status:    changed_front.status)
      FactoryGirl.create(:market,    market:    valid_front.market)
      FactoryGirl.create(:segment,   segment:   valid_front.segment)
      FactoryGirl.create(:site,      site:      valid_front.site)
      FactoryGirl.create(:app_layer, app_layer: valid_front.app_layer)
      FactoryGirl.create(:pipe,      pipe:      valid_front.pipe)
      FactoryGirl.create(:status,    status:    valid_front.status)
      visit edit_front_path valid_front.id
    end

    describe "with valid information" do
      before do
        select changed_front.market,    from: "Market"
        select changed_front.segment,   from: "Segment"
        select changed_front.site,      from: "Site"
        select changed_front.app_layer, from: "App layer"
        select changed_front.pipe,      from: "Pipe"
        select changed_front.status,    from: "Status"
        fill_in "Notes", with: changed_front.notes
      end

      it "should save the new information" do
        click_button("Submit")
        valid_front.reload
        expect(valid_front.market).to eq changed_front.market
        expect(valid_front.segment).to eq changed_front.segment
        expect(valid_front.site).to eq changed_front.site
        expect(valid_front.app_layer).to eq changed_front.app_layer
        expect(valid_front.pipe).to eq changed_front.pipe
        expect(valid_front.status).to eq changed_front.status
        expect(valid_front.notes).to eq changed_front.notes
      end

      it "should flass a success message" do
        click_button("Submit")
        expect(page).to have_content("Front successfully changed")
      end
    end
  end
end
