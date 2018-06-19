require "./spec_helper"

describe Steam::ID do
  it "constructs ID from SID2" do
    test_data.each do |data|
      sid = Steam::ID.new
      sid.universe = data.universe
      sid.type = data.type
      sid.instance = data.instance
      sid.account_id = data.account_id

      Steam::ID.new(data.sid2).should eq sid
    end
  end

  it "constructs with newer format id from SID2" do
    sid = Steam::ID.new
    sid.universe = Steam::ID::Universe::Public
    sid.type = Steam::ID::Type::Individual
    sid.instance = Steam::ID::Instance::Desktop
    sid.account_id = 46143803_u64

    Steam::ID.new("STEAM_1:1:23071901").should eq sid
  end

  it "correctly renders SID2" do
    sid = Steam::ID.new
    sid.universe = Steam::ID::Universe::Public
    sid.type = Steam::ID::Type::Individual
    sid.instance = Steam::ID::Instance::Desktop
    sid.account_id = 46143802_u64

    sid.to_sid2.should eq "STEAM_0:0:23071901"
  end

  it "correctly renders with newer format" do
    sid = Steam::ID.new
    sid.universe = Steam::ID::Universe::Public
    sid.type = Steam::ID::Type::Individual
    sid.instance = Steam::ID::Instance::Desktop
    sid.account_id = 46143802_u64

    sid.to_sid2(true).should eq "STEAM_1:0:23071901"
  end

  it "throw when tries to render non-individual ID" do
    sid = Steam::ID.new
    sid.universe = Steam::ID::Universe::Public
    sid.type = Steam::ID::Type::Clan
    sid.instance = Steam::ID::Instance::Desktop
    sid.account_id = 4681548_u64

    expect_raises(Exception) do
      sid.to_sid2 true
    end
  end
end
