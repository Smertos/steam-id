require "./spec_helper"

describe Steam::ID do
  it "constructs without parameters" do
    sid = Steam::ID.new
    sid.universe = Steam::ID::Universe::Invalid
    sid.type = Steam::ID::Type::Invalid
    sid.instance = Steam::ID::Instance::All
    sid.account_id = 0_u64

    Steam::ID.new.should eq sid
  end

  it "constructs using from_individual_account_id" do
    test_data.each do |data|
      sid = Steam::ID.new
      sid.universe = Steam::ID::Universe::Public
      sid.type = Steam::ID::Type::Individual
      sid.instance = Steam::ID::Instance::Desktop
      sid.account_id = data.account_id

      Steam::ID.from_individual_account_id(data.account_id).should eq sid
    end
  end

  it "throw error if incorrect input has been given to the constructor" do
    expect_raises(Exception) do
      Steam::ID.new "invalid input"
    end
  end

  it "invalidates empty id" do
    Steam::ID.new.is_valid.should eq false
  end

  it "invalidates individual id" do
    Steam::ID.new("[U:1:46143802:10]").is_valid.should eq false
  end

  it "invalidates non-all clan ID" do
    Steam::ID.new("[g:1:4681548:2]").is_valid.should eq false
  end

  it "invalidates gameserver ID with account_id 0" do
    Steam::ID.new("[G:1:0]").is_valid.should eq false
  end
end
