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

      before do
        fill_in "Market",    with: front.market
        fill_in "Segment",   with: front.segment
        fill_in "Site",      with: front.site
        fill_in "App layer", with: front.app_layer
        fill_in "Pipe",      with: front.pipe
        fill_in "Status",    with: front.status
        fill_in "Notes",     with: front.notes
      end

      it "should create the Front" do
    
        expect{click_button("Create")}.to change{Front.count}.by(1)
      end

      it "should flash a success message" do
        click_button("Create")
        expect(page).to have_content "Front successfully created"  
      end
    end

  end

  describe "deleting a front" do
    let!(:front) { FactoryGirl.create(:front) }

    before do
      # visit edit_front_path(front.id)
      pending
    end

    it "should delete the front" do
      expect(click_link("Delete")).to change{Front.count}.by(-1)
    end

  end

  describe "editing a front" do
    let!(:valid_front)   { FactoryGirl.create(:front) }
    let!(:changed_front) { FactoryGirl.build(:front) }

    before { visit edit_front_path valid_front.id }

      it "should require required fields" do
        @front = Front.new
        @front.save
        @error_messages = @front.errors.full_messages
        expect(@error_messages.count).to be > 0

        fill_in "Market",    with: ""
        fill_in "Segment",   with: "" 
        fill_in "Site",      with: "" 
        fill_in "App layer", with: ""
        fill_in "Pipe",      with: ""
        fill_in "Status",    with: ""
        fill_in "Notes",     with: ""
        click_button("Save")

        @error_messages.each do |message|
          expect(page).to have_content(message)
        end
      end

      describe "with valid information" do
        before do
          fill_in "Market",    with: changed_front.market
          fill_in "Segment",   with: changed_front.segment
          fill_in "Site",      with: changed_front.site
          fill_in "App layer", with: changed_front.app_layer
          fill_in "Pipe",      with: changed_front.pipe
          fill_in "Status",    with: changed_front.status
          fill_in "Notes",     with: changed_front.notes
        end

        it "should save the new information" do
          click_button("Save")
          valid_front.reload
          expect(valid_front.market).to eq changed_front.market
          expect(valid_front.segment).to eq changed_front.segment
          expect(valid_front.site).to eq changed_front.site
          expect(valid_front.app_layer).to eq changed_front.app_layer
          expect(valid_front.pipe).to eq changed_front.pipe
          expect(valid_front.status).to eq changed_front.status
          expect(valid_front.notes).to eq changed_front.notes
        end
      end





  end
end
