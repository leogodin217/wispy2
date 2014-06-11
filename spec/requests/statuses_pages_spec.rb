require 'rails_helper'

describe "Status pages" do
  subject { page }

  describe "showing a status" do
    let!(:status) {FactoryGirl.create(:status) }

    before {visit status_path(status.id) }

    it { should have_selector "li", text: status.status }
    it { should have_selector "li", text: status.active ? 'Active' : 'Not active' }
    it { should have_link "Edit", href: edit_status_path(status.id) }
    it { should have_selector "a[href='#{status_path(status.id)}'][data-method='delete']" }
  end

  describe "listing statuses" do
    before do
      3.times do
        FactoryGirl.create(:status)
      end

      visit statuses_path
    end
    let(:statuses) { Status.all }

    it { should have_link "New Status", new_status_path }

    it "should show all statuses" do
      statuses.each do |current_status|
        expect(page).to have_selector "tr", text: current_status.status
      end
    end

    it "should have show links" do
      statuses.each do |current_status|
        expect(page).to have_link "Show", status_path(current_status)
      end
    end


  end

  describe "creating a status" do
    let(:status) {FactoryGirl.build(:status) }

    before do
      visit statuses_path
      click_link "New Status"
    end

    describe "with invalid information" do

      before { click_button "Submit" }

      it "should re-display the form" do
        expect(page).to have_selector "form#new_status"
      end

      it "should show error count" do
        @status = Status.new
        @status.save
        @error_count = @status.errors.count
        expect(page).to have_content(
          "The form contains #{@error_count} #{'error'.pluralize(@error_count) }"
        )

      end

      it "should require required fields" do
        @status = Status.new
        @status.save
        @error_messages = @status.errors.full_messages

        @error_messages.each do |message|
          expect(page).to have_content(message)
        end
      end

    end


    describe "with valid information" do

      before do
        fill_in "Status",    with: status.status
        check "Active"
      end

      it "should create the Status" do

        expect{click_button("Submit")}.to change{Status.count}.by(1)
      end

      it "should flash a success message" do
        click_button("Submit")
        expect(page).to have_content "Status successfully created"
      end
    end

  end

  describe "deleting a status" do
    let!(:status) { FactoryGirl.create(:status) }

    before do
      visit status_path(status.id)
    end

    it "should delete the status" do
      expect{click_link("Delete")}.to change{Status.count}.by(-1)
    end

    it "should flash a success message" do
      click_link "Delete"
      expect(page).to have_content "Status successfully destroyed."
    end

    it "should redirect to the statuses index" do
      click_link "Delete"
      expect(page.current_url).to eq statuses_url
    end

  end

  describe "editing a status" do
    let!(:valid_status)   { FactoryGirl.create(:status) }
    let!(:changed_status) { FactoryGirl.build(:status, active: false) }

    before { visit edit_status_path valid_status.id }

      it "should require required fields" do
        @status = Status.new
        @status.save
        @error_messages = @status.errors.full_messages
        expect(@error_messages.count).to be > 0

        fill_in "Status",    with: ""
        click_button("Submit")

        @error_messages.each do |message|
          expect(page).to have_content(message)
        end
      end

      describe "with valid information" do
        before do
          fill_in "Status",    with: changed_status.status
          uncheck "Active"
        end

        it "should save the new information" do
          click_button("Submit")
          valid_status.reload
          expect(valid_status.status).to eq changed_status.status
          expect(valid_status.active).to eq changed_status.active
        end

        it "should flass a success message" do
          click_button("Submit")
          expect(page).to have_content("Status successfully changed")
        end
      end
  end
end
