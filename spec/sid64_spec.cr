require "./spec_helper"

describe Steam::ID do
  it "constructs individual id from SID64" do
    sid = Steam::ID.new
    sid.universe = Steam::ID::Universe::Public
    sid.type = Steam::ID::Type::Individual
    sid.instance = Steam::ID::Instance::Desktop
    sid.account_id = 46143802_u64

    Steam::ID.new("76561198006409530").should eq sid
  end

  it "constructs clan id from SID64" do
    sid = Steam::ID.new
    sid.universe = Steam::ID::Universe::Public
    sid.type = Steam::ID::Type::Clan
    sid.instance = Steam::ID::Instance::All
    sid.account_id = 4681548_u64

    Steam::ID.new("103582791434202956").should eq sid
  end

  it "correctly renders individual id as SID64" do
    sid = Steam::ID.new
    sid.universe = Steam::ID::Universe::Public
    sid.type = Steam::ID::Type::Individual
    sid.instance = Steam::ID::Instance::Desktop
    sid.account_id = 46143802_u64

    sid.to_sid64.should eq "76561198006409530"
  end

  it "correctly renders anonymous gameserver id as SID64" do
    sid = Steam::ID.new
    sid.universe = Steam::ID::Universe::Public
    sid.type = Steam::ID::Type::AnonymousGameServer
    sid.instance = Steam::ID::Instance.new 188991_u64
    sid.account_id = 42135013_u64

    sid.to_sid64.should eq "90883702753783269"
  end
end
