require 'rails_helper'

describe "Pipe pages" do
  subject { page }

  describe "showing a pipe" do
    let!(:pipe) {FactoryGirl.create(:pipe) }

    before {visit pipe_path(pipe.id) }

    it { should have_selector "li", text: pipe.pipe }
    it { should have_selector "li", text: pipe.active ? 'Active' : 'Not active' }
    it { should have_link "Edit", href: edit_pipe_path(pipe.id) }
    it { should have_selector "a[href='#{pipe_path(pipe.id)}'][data-method='delete']" }
  end

  describe "listing pipes" do
    before do
      3.times do
        FactoryGirl.create(:pipe)
      end

      visit pipes_path
    end
    let(:pipes) { Pipe.all }

    it { should have_link "New Pipe", new_pipe_path }

    it "should show all pipes" do
      pipes.each do |current_pipe|
        expect(page).to have_selector "tr", text: current_pipe.pipe
      end
    end

    it "should have show links" do
      pipes.each do |current_pipe|
        expect(page).to have_link "Show", pipe_path(current_pipe)
      end
    end


  end

  describe "creating a pipe" do
    let(:pipe) {FactoryGirl.build(:pipe) }

    before do
      visit pipes_path
      click_link "New Pipe"
    end

    describe "with invalid information" do

      before { click_button "Submit" }

      it "should re-display the form" do
        expect(page).to have_selector "form#new_pipe"
      end

      it "should show error count" do
        @pipe = Pipe.new
        @pipe.save
        @error_count = @pipe.errors.count
        expect(page).to have_content(
          "The form contains #{@error_count} #{'error'.pluralize(@error_count) }"
        )

      end

      it "should require required fields" do
        @pipe = Pipe.new
        @pipe.save
        @error_messages = @pipe.errors.full_messages

        @error_messages.each do |message|
          expect(page).to have_content(message)
        end
      end

    end


    describe "with valid information" do

      before do
        fill_in "Pipe",    with: pipe.pipe
        check "Active"
      end

      it "should create the Pipe" do

        expect{click_button("Submit")}.to change{Pipe.count}.by(1)
      end

      it "should flash a success message" do
        click_button("Submit")
        expect(page).to have_content "Pipe successfully created"
      end
    end

  end

  describe "deleting a pipe" do
    let!(:pipe) { FactoryGirl.create(:pipe) }

    before do
      visit pipe_path(pipe.id)
    end

    it "should delete the pipe" do
      expect{click_link("Delete")}.to change{Pipe.count}.by(-1)
    end

    it "should flash a success message" do
      click_link "Delete"
      expect(page).to have_content "Pipe successfully destroyed."
    end

    it "should redirect to the pipes index" do
      click_link "Delete"
      expect(page.current_url).to eq pipes_url
    end

  end

  describe "editing a pipe" do
    let!(:valid_pipe)   { FactoryGirl.create(:pipe) }
    let!(:changed_pipe) { FactoryGirl.build(:pipe, active: false) }

    before { visit edit_pipe_path valid_pipe.id }

      it "should require required fields" do
        @pipe = Pipe.new
        @pipe.save
        @error_messages = @pipe.errors.full_messages
        expect(@error_messages.count).to be > 0

        fill_in "Pipe",    with: ""
        click_button("Submit")

        @error_messages.each do |message|
          expect(page).to have_content(message)
        end
      end

      describe "with valid information" do
        before do
          fill_in "Pipe",    with: changed_pipe.pipe
          uncheck "Active"
        end

        it "should save the new information" do
          click_button("Submit")
          valid_pipe.reload
          expect(valid_pipe.pipe).to eq changed_pipe.pipe
          expect(valid_pipe.active).to eq changed_pipe.active
        end

        it "should flass a success message" do
          click_button("Submit")
          expect(page).to have_content("Pipe successfully changed")
        end
      end
  end
end
