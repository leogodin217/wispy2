require 'rails_helper'

describe "Segment pages" do
  subject { page }

  describe "showing a segment" do
    let!(:segment) {FactoryGirl.create(:segment) }

    before {visit segment_path(segment.id) }

    it { should have_selector "li", text: segment.segment }
    it { should have_selector "li", text: segment.active ? 'Active' : 'Not active' }
    it { should have_link "Edit", href: edit_segment_path(segment.id) }
    it { should have_selector "a[href='#{segment_path(segment.id)}'][data-method='delete']" }
  end

  describe "listing segments" do
    before do
      3.times do
        FactoryGirl.create(:segment)
      end

      visit segments_path
    end
    let(:segments) { Segment.all }

    it { should have_link "New Segment", new_segment_path }

    it "should show all segments" do
      segments.each do |current_segment|
        expect(page).to have_selector "tr", text: current_segment.segment
      end
    end

    it "should have show links" do
      segments.each do |current_segment|
        expect(page).to have_link "Show", segment_path(current_segment)
      end
    end


  end

  describe "creating a segment" do
    let(:segment) {FactoryGirl.build(:segment) }

    before do
      visit segments_path
      click_link "New Segment"
    end

    describe "with invalid information" do

      before { click_button "Submit" }

      it "should re-display the form" do
        expect(page).to have_selector "form#new_segment"
      end

      it "should show error count" do
        @segment = Segment.new
        @segment.save
        @error_count = @segment.errors.count
        expect(page).to have_content(
          "The form contains #{@error_count} #{'error'.pluralize(@error_count) }"
        )

      end

      it "should require required fields" do
        @segment = Segment.new
        @segment.save
        @error_messages = @segment.errors.full_messages

        @error_messages.each do |message|
          expect(page).to have_content(message)
        end
      end

    end


    describe "with valid information" do

      before do
        fill_in "Segment",    with: segment.segment
        check "Active"
      end

      it "should create the Segment" do

        expect{click_button("Submit")}.to change{Segment.count}.by(1)
      end

      it "should flash a success message" do
        click_button("Submit")
        expect(page).to have_content "Segment successfully created"
      end
    end

  end

  describe "deleting a segment" do
    let!(:segment) { FactoryGirl.create(:segment) }

    before do
      visit segment_path(segment.id)
    end

    it "should delete the segment" do
      expect{click_link("Delete")}.to change{Segment.count}.by(-1)
    end

    it "should flash a success message" do
      click_link "Delete"
      expect(page).to have_content "Segment successfully destroyed."
    end

    it "should redirect to the segments index" do
      click_link "Delete"
      expect(page.current_url).to eq segments_url
    end

  end

  describe "editing a segment" do
    let!(:valid_segment)   { FactoryGirl.create(:segment) }
    let!(:changed_segment) { FactoryGirl.build(:segment, active: false) }

    before { visit edit_segment_path valid_segment.id }

      it "should require required fields" do
        @segment = Segment.new
        @segment.save
        @error_messages = @segment.errors.full_messages
        expect(@error_messages.count).to be > 0

        fill_in "Segment",    with: ""
        click_button("Submit")

        @error_messages.each do |message|
          expect(page).to have_content(message)
        end
      end

      describe "with valid information" do
        before do
          fill_in "Segment",    with: changed_segment.segment
          uncheck "Active"
        end

        it "should save the new information" do
          click_button("Submit")
          valid_segment.reload
          expect(valid_segment.segment).to eq changed_segment.segment
          expect(valid_segment.active).to eq changed_segment.active
        end

        it "should flass a success message" do
          click_button("Submit")
          expect(page).to have_content("Segment successfully changed")
        end
      end
  end
end
