require 'rails_helper'

describe "Market pages" do
  subject { page }

  describe "showing a market" do
    let!(:market) {FactoryGirl.create(:market) }

    before {visit market_path(market.id) }

    it { should have_selector "li", text: market.market }
    it { should have_selector "li", text: market.active ? 'Active' : 'Not active' }
    it { should have_link "Edit", href: edit_market_path(market.id) }
    it { should have_selector "a[href='#{market_path(market.id)}'][data-method='delete']" }
  end

  describe "listing markets" do
    before do
      3.times do
        FactoryGirl.create(:market)
      end

      visit markets_path
    end
    let(:markets) { Market.all }

    it { should have_link "New Market", new_market_path }

    it "should show all markets" do
      markets.each do |current_market|
        expect(page).to have_selector "tr", text: current_market.market
      end
    end

    it "should have show links" do
      markets.each do |current_market|
        expect(page).to have_link "Show", market_path(current_market)
      end
    end


  end

  describe "creating a market" do
    let(:market) {FactoryGirl.build(:market) }

    before do
      visit markets_path
      click_link "New Market"
    end

    describe "with invalid information" do

      before { click_button "Submit" }

      it "should re-display the form" do
        expect(page).to have_selector "form#new_market"
      end

      it "should show error count" do
        @market = Market.new
        @market.save
        @error_count = @market.errors.count
        expect(page).to have_content(
          "The form contains #{@error_count} #{'error'.pluralize(@error_count) }"
        )

      end

      it "should require required fields" do
        @market = Market.new
        @market.save
        @error_messages = @market.errors.full_messages

        @error_messages.each do |message|
          expect(page).to have_content(message)
        end
      end

    end


    describe "with valid information" do

      before do
        fill_in "Market",    with: market.market
        check "Active"
      end

      it "should create the Market" do

        expect{click_button("Submit")}.to change{Market.count}.by(1)
      end

      it "should flash a success message" do
        click_button("Submit")
        expect(page).to have_content "Market successfully created"
      end
    end

  end

  describe "deleting a market" do
    let!(:market) { FactoryGirl.create(:market) }

    before do
      visit market_path(market.id)
    end

    it "should delete the market" do
      expect{click_link("Delete")}.to change{Market.count}.by(-1)
    end

    it "should flash a success message" do
      click_link "Delete"
      expect(page).to have_content "Market successfully destroyed."
    end

    it "should redirect to the markets index" do
      click_link "Delete"
      expect(page.current_url).to eq markets_url
    end

  end

  describe "editing a market" do
    let!(:valid_market)   { FactoryGirl.create(:market) }
    let!(:changed_market) { FactoryGirl.build(:market, active: false) }

    before { visit edit_market_path valid_market.id }

      it "should require required fields" do
        @market = Market.new
        @market.save
        @error_messages = @market.errors.full_messages
        expect(@error_messages.count).to be > 0

        fill_in "Market",    with: ""
        click_button("Submit")

        @error_messages.each do |message|
          expect(page).to have_content(message)
        end
      end

      describe "with valid information" do
        before do
          fill_in "Market",    with: changed_market.market
          uncheck "Active"
        end

        it "should save the new information" do
          click_button("Submit")
          valid_market.reload
          expect(valid_market.market).to eq changed_market.market
          expect(valid_market.active).to eq changed_market.active
        end

        it "should flass a success message" do
          click_button("Submit")
          expect(page).to have_content("Market successfully changed")
        end
      end
  end
end
