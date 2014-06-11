require 'rails_helper'

describe "Site pages" do
  subject { page }

  describe "showing a site" do
    let!(:site) {FactoryGirl.create(:site) }

    before {visit site_path(site.id) }

    it { should have_selector "li", text: site.site }
    it { should have_selector "li", text: site.active ? 'Active' : 'Not active' }
    it { should have_link "Edit", href: edit_site_path(site.id) }
    it { should have_selector "a[href='#{site_path(site.id)}'][data-method='delete']" }
  end

  describe "listing sites" do
    before do
      3.times do
        FactoryGirl.create(:site)
      end

      visit sites_path
    end
    let(:sites) { Site.all }

    it { should have_link "New Site", new_site_path }

    it "should show all sites" do
      sites.each do |current_site|
        expect(page).to have_selector "tr", text: current_site.site
      end
    end

    it "should have show links" do
      sites.each do |current_site|
        expect(page).to have_link "Show", site_path(current_site)
      end
    end


  end

  describe "creating a site" do
    let(:site) {FactoryGirl.build(:site) }

    before do
      visit sites_path
      click_link "New Site"
    end

    describe "with invalid information" do

      before { click_button "Submit" }

      it "should re-display the form" do
        expect(page).to have_selector "form#new_site"
      end

      it "should show error count" do
        @site = Site.new
        @site.save
        @error_count = @site.errors.count
        expect(page).to have_content(
          "The form contains #{@error_count} #{'error'.pluralize(@error_count) }"
        )

      end

      it "should require required fields" do
        @site = Site.new
        @site.save
        @error_messages = @site.errors.full_messages

        @error_messages.each do |message|
          expect(page).to have_content(message)
        end
      end

    end


    describe "with valid information" do

      before do
        fill_in "Site",    with: site.site
        check "Active"
      end

      it "should create the Site" do

        expect{click_button("Submit")}.to change{Site.count}.by(1)
      end

      it "should flash a success message" do
        click_button("Submit")
        expect(page).to have_content "Site successfully created"
      end
    end

  end

  describe "deleting a site" do
    let!(:site) { FactoryGirl.create(:site) }

    before do
      visit site_path(site.id)
    end

    it "should delete the site" do
      expect{click_link("Delete")}.to change{Site.count}.by(-1)
    end

    it "should flash a success message" do
      click_link "Delete"
      expect(page).to have_content "Site successfully destroyed."
    end

    it "should redirect to the sites index" do
      click_link "Delete"
      expect(page.current_url).to eq sites_url
    end

  end

  describe "editing a site" do
    let!(:valid_site)   { FactoryGirl.create(:site) }
    let!(:changed_site) { FactoryGirl.build(:site, active: false) }

    before { visit edit_site_path valid_site.id }

      it "should require required fields" do
        @site = Site.new
        @site.save
        @error_messages = @site.errors.full_messages
        expect(@error_messages.count).to be > 0

        fill_in "Site",    with: ""
        click_button("Submit")

        @error_messages.each do |message|
          expect(page).to have_content(message)
        end
      end

      describe "with valid information" do
        before do
          fill_in "Site",    with: changed_site.site
          uncheck "Active"
        end

        it "should save the new information" do
          click_button("Submit")
          valid_site.reload
          expect(valid_site.site).to eq changed_site.site
          expect(valid_site.active).to eq changed_site.active
        end

        it "should flass a success message" do
          click_button("Submit")
          expect(page).to have_content("Site successfully changed")
        end
      end
  end
end
