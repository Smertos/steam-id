require "./spec_helper"

describe Steam::ID do
  it "constructs individual id from SID3" do
    sid = Steam::ID.new
    sid.universe = Steam::ID::Universe::Public
    sid.type = Steam::ID::Type::Individual
    sid.instance = Steam::ID::Instance::Desktop
    sid.account_id = 46143802_u64

    Steam::ID.new("[U:1:46143802]").should eq sid
  end

  it "constructs anonymous gameserver id from SID3" do
    sid = Steam::ID.new
    sid.universe = Steam::ID::Universe::Public
    sid.type = Steam::ID::Type::AnonymousGameServer
    sid.instance = Steam::ID::Instance.new 11245_u64
    sid.account_id = 46124_u64

    Steam::ID.new("[A:1:46124:11245]").should eq sid
  end

  it "constructs lobbyy id from sid3" do
    sid = Steam::ID.new
    sid.universe = Steam::ID::Universe::Public
    sid.type = Steam::ID::Type::Chat
    sid.instance = Steam::ID::Instance.new Steam::ID::ChatInstanceFlags::Lobby.value
    sid.account_id = 12345_u64

    Steam::ID.new("[L:1:12345]").should eq sid
  end

  it "constructs lobby id with instanceID from sid3" do
    sid = Steam::ID.new
    sid.universe = Steam::ID::Universe::Public
    sid.type = Steam::ID::Type::Chat
    sid.instance = Steam::ID::Instance.new Steam::ID::ChatInstanceFlags::Lobby.value | 55
    sid.account_id = 12345_u64

    Steam::ID.new("[L:1:12345:55]").should eq sid
  end

  it "correctly renders individual id as SID3" do
    sid = Steam::ID.new
    sid.universe = Steam::ID::Universe::Public
    sid.type = Steam::ID::Type::Individual
    sid.instance = Steam::ID::Instance::Desktop
    sid.account_id = 46143802_u64

    sid.to_sid3.should eq "[U:1:46143802]"
  end

  it "correctly renders anonymous gameserver id as SID3" do
    sid = Steam::ID.new
    sid.universe = Steam::ID::Universe::Public
    sid.type = Steam::ID::Type::AnonymousGameServer
    sid.instance = Steam::ID::Instance.new 41511_u64
    sid.account_id = 43253156_u64

    sid.to_sid3.should eq "[A:1:43253156:41511]"
  end

  it "correctly renders lobby id as SID3" do
    sid = Steam::ID.new
    sid.universe = Steam::ID::Universe::Public
    sid.type = Steam::ID::Type::Chat
    sid.instance = Steam::ID::Instance.new Steam::ID::ChatInstanceFlags::Lobby.value
    sid.account_id = 451932_u64

    sid.to_sid3.should eq "[L:1:451932]"
  end
end
