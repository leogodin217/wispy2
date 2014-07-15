require 'rails_helper'

RSpec.describe Front, :type => :model do
  let!(:front) { FactoryGirl.create :front }

  subject { front }

  it { should respond_to :market }
  it { should respond_to :segment }
  it { should respond_to :site}
  it { should respond_to :app_layer }
  it { should respond_to :pipe }
  it { should respond_to :status }
  it { should respond_to :notes }
  it { should respond_to :full_name }
  it { should respond_to :clusters }
  its(:full_name) { should eq front.market +
                              "-" +
                              front.segment +
                              "-" +
                              front.site +
                              "-" +
                              front.app_layer +
                              "-" +
                              front.pipe }
  describe "validation" do
    it "should have many clusters" do
      front.clusters.create(name: "cluster1")
      front.clusters.create(name: "cluster2")
      expect(front.clusters.to_a.length).to eq 2
    end
  end

  describe "required fields" do

    it "should require a market" do
      front.market = ""
      expect(front).to_not be_valid
    end

    it "should require a segment" do
      front.segment = ""
      expect(front).to_not be_valid
    end

    it "should require a site" do
      front.site = ""
      expect(front).to_not be_valid
    end

    it "should require a app_layer" do
      front.app_layer = ""
      expect(front).to_not be_valid
    end

    it "should require a pipe" do
      front.pipe = ""
      expect(front).to_not be_valid
    end

    it "should require a status" do
      front.status = ""
      expect(front).to_not be_valid
    end

  end
end
