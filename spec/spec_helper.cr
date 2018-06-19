require "spec"
require "../src/steam-id"

alias TestData = NamedTuple(
  sid2: String, sid3: String, sid64: String,
  universe: UInt64, type: UInt64, instance: UInt64, account_id: UInt64)

struct TestID
  property sid2 : String
  property sid3 : String
  property sid64 : String
  property account_id : UInt64
  property type : Steam::ID::Type
  property instance : Steam::ID::Instance
  property universe : Steam::ID::Universe

  def initialize(
       @sid2, @sid3, @sid64,
       @account_id,
       type = 0_u64,
       instance = 0_u64,
       universe = 0_u64
     )
    @type = Steam::ID::Type.new type
    @instance = Steam::ID::Instance.new instance
    @universe = Steam::ID::Universe.new universe
  end
end

def test_data
  [
    TestID.new(
      "STEAM_0:0:23071901", "[U:1:46143802]", "76561198006409530",
      46143802.to_u64, 1.to_u64, 1.to_u64, 1.to_u64),
    TestID.new(
      "STEAM_0:1:59569542", "[U:1:119139085]", "76561198079404813",
      119139085.to_u64, 1.to_u64, 1.to_u64, 1.to_u64)
  ]
end
