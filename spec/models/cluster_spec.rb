require 'rails_helper'

RSpec.describe Cluster, :type => :model do
  let(:cluster) { FactoryGirl.create :cluster }

  subject { cluster }

  it { should respond_to :name }
  it { should respond_to :front }

  describe "relationships" do

    it "should belong to a Front" do
      expect(cluster.front).to be_an(Front)
    end

  end

  describe "validation" do

    it "should require a name" do
      cluster.name = ""
      expect(cluster).to_not be_valid
    end

  end
end
