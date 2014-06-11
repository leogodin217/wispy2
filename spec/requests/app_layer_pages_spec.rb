require 'rails_helper'

describe "AppLayer pages" do
  subject { page }

  describe "showing a app_layer" do
    let!(:app_layer) {FactoryGirl.create(:app_layer) }

    before {visit app_layer_path(app_layer.id) }

    it { should have_selector "li", text: app_layer.app_layer }
    it { should have_selector "li", text: app_layer.active ? 'Active' : 'Not active' }
    it { should have_link "Edit", href: edit_app_layer_path(app_layer.id) }
    it { should have_selector "a[href='#{app_layer_path(app_layer.id)}'][data-method='delete']" }
  end

  describe "listing app_layers" do
    before do
      3.times do
        FactoryGirl.create(:app_layer)
      end

      visit app_layers_path
    end
    let(:app_layers) { AppLayer.all }

    it { should have_link "New App layer", new_app_layer_path }

    it "should show all app_layers" do
      app_layers.each do |current_app_layer|
        expect(page).to have_selector "tr", text: current_app_layer.app_layer
      end
    end

    it "should have show links" do
      app_layers.each do |current_app_layer|
        expect(page).to have_link "Show", app_layer_path(current_app_layer)
      end
    end


  end

  describe "creating a app_layer" do
    let(:app_layer) {FactoryGirl.build(:app_layer) }

    before do
      visit app_layers_path
      click_link "New App layer"
    end

    describe "with invalid information" do

      before { click_button "Submit" }

      it "should re-display the form" do
        expect(page).to have_selector "form#new_app_layer"
      end

      it "should show error count" do
        @app_layer = AppLayer.new
        @app_layer.save
        @error_count = @app_layer.errors.count
        expect(page).to have_content(
          "The form contains #{@error_count} #{'error'.pluralize(@error_count) }"
        )

      end

      it "should require required fields" do
        @app_layer = AppLayer.new
        @app_layer.save
        @error_messages = @app_layer.errors.full_messages

        @error_messages.each do |message|
          expect(page).to have_content(message)
        end
      end

    end


    describe "with valid information" do

      before do
        fill_in "App layer",    with: app_layer.app_layer
        check "Active"
      end

      it "should create the App layer" do

        expect{click_button("Submit")}.to change{AppLayer.count}.by(1)
      end

      it "should flash a success message" do
        click_button("Submit")
        expect(page).to have_content "App layer successfully created"
      end
    end

  end

  describe "deleting a app_layer" do
    let!(:app_layer) { FactoryGirl.create(:app_layer) }

    before do
      visit app_layer_path(app_layer.id)
    end

    it "should delete the app_layer" do
      expect{click_link("Delete")}.to change{AppLayer.count}.by(-1)
    end

    it "should flash a success message" do
      click_link "Delete"
      expect(page).to have_content "App layer successfully destroyed."
    end

    it "should redirect to the app_layers index" do
      click_link "Delete"
      expect(page.current_url).to eq app_layers_url
    end

  end

  describe "editing a app_layer" do
    let!(:valid_app_layer)   { FactoryGirl.create(:app_layer) }
    let!(:changed_app_layer) { FactoryGirl.build(:app_layer, active: false) }

    before { visit edit_app_layer_path valid_app_layer.id }

      it "should require required fields" do
        @app_layer = AppLayer.new
        @app_layer.save
        @error_messages = @app_layer.errors.full_messages
        expect(@error_messages.count).to be > 0

        fill_in "App layer",    with: ""
        click_button("Submit")

        @error_messages.each do |message|
          expect(page).to have_content(message)
        end
      end

      describe "with valid information" do
        before do
          fill_in "App layer",    with: changed_app_layer.app_layer
          uncheck "Active"
        end

        it "should save the new information" do
          click_button("Submit")
          valid_app_layer.reload
          expect(valid_app_layer.app_layer).to eq changed_app_layer.app_layer
          expect(valid_app_layer.active).to eq changed_app_layer.active
        end

        it "should flass a success message" do
          click_button("Submit")
          expect(page).to have_content("App layer successfully changed")
        end
      end
  end
end
