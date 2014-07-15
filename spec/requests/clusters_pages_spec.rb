require 'rails_helper'

describe "Cluster pages" do
  subject { page }
  describe "showing a cluster" do
    let!(:cluster) { FactoryGirl.create(:cluster) }

    before { visit cluster_path(cluster.id) }

    it { should have_selector "dl>dd", text: cluster.name }
    it { should have_selector "dl>dd", text: cluster.front.full_name }
    it { should have_selector "dl>dd", text: cluster.notes }
    it { should have_link "Edit", href: edit_cluster_path(cluster.id) }
    it { should have_selector "a[href='#{cluster_path(cluster.id)}'][data-method='delete']" }
  end

  describe "listing clusters" do
    before do
      3.times do
        FactoryGirl.create(:cluster)
      end

      visit clusters_path
    end
    let(:clusters) { Cluster.all }

    it { should have_link "New Cluster", new_cluster_path }

    it "should show all clusters" do
      clusters.each do |current_cluster|
        expect(page).to have_selector "tr", text: current_cluster.name
      end
    end

    it "should have show links" do
      clusters.each do |current_cluster|
        expect(page).to have_link "Show", cluster_path(current_cluster)
      end
    end


  end

  describe "creating a cluster" do

    before do
      # Setup select options
      FactoryGirl.create(:status)
      FactoryGirl.create(:front)
      visit clusters_path
      click_link "New Cluster"
    end

    describe "with invalid information" do
    let(:cluster) {FactoryGirl.build(:cluster) }

      before do
        visit new_cluster_path
        puts page.body
        click_button "Submit"
      end

      it "should re-display the form" do
        expect(page).to have_selector "form#new_cluster"
      end

      # Cluster name is the only field that isn't selected from a
      # menu, so there should only be one error
      it { should have_content "Name can't be blank" }
      it { should have_content "The form contains 1 error" }
    end


    describe "with valid information" do
      let(:cluster) { FactoryGirl.build(:cluster) }

      before do
        # Create the menus

        FactoryGirl.create(:status, status: cluster.status)
        visit new_cluster_path

        fill_in "Name",                 with: cluster.name
        select cluster.front.full_name, from: "Front"
        select cluster.status,          from: "Status"
        fill_in "Notes",                with: cluster.notes
      end

      it "should create the Cluster" do
        expect{click_button("Submit")}.to change{Cluster.count}.by(1)
      end

      it "should flash a success message" do
        click_button("Submit")
        expect(page).to have_content "Cluster successfully created"
      end
    end

  end

  describe "deleting a cluster" do
    let!(:cluster) { FactoryGirl.create(:cluster) }

    before do
      visit cluster_path(cluster.id)
    end

    it "should delete the cluster" do
      expect{click_link("Delete")}.to change{Cluster.count}.by(-1)
    end

    it "should flash a success message" do
      click_link "Delete"
      expect(page).to have_content "Cluster successfuly destroyed."
    end

    it "should redirect to the clusters index" do
      click_link "Delete"
      expect(page.current_url).to eq clusters_url
    end

  end

  describe "editing a cluster" do
    let!(:valid_cluster)   { FactoryGirl.create(:cluster) }
    let!(:changed_cluster) { FactoryGirl.build(:cluster) }

    before do
      # Create menus for both clusters
      FactoryGirl.create(:status, status: changed_cluster.status)
      FactoryGirl.create(:status, status: valid_cluster.status)
      visit edit_cluster_path valid_cluster.id
    end

    describe "with valid information" do
      before do
        fill_in "Name",                         with: changed_cluster.name
        select changed_cluster.front.full_name, from: "Front"
        select changed_cluster.status,          from: "Status"
        fill_in "Notes",                        with: changed_cluster.notes
      end

      it "should save the new information" do
        click_button("Submit")
        valid_cluster.reload
        expect(valid_cluster.name).to eq changed_cluster.name
        expect(valid_cluster.front.id).to eq changed_cluster.front.id
        expect(valid_cluster.status).to eq changed_cluster.status
        expect(valid_cluster.notes).to eq changed_cluster.notes
      end

      it "should flass a success message" do
        click_button("Submit")
        expect(page).to have_content("Cluster successfully changed")
      end
    end
  end
end
