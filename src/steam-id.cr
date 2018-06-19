require "big"

module Steam
  class ID
    VERSION = "1.0.0"

    enum Universe : UInt64
      Invalid
      Public
      Beta
      Internal
      Dev
      RC
    end

    enum Type : UInt64
      Invalid
      Individual
      Multiseat
      Gameserver
      AnonymousGameServer
      Pending
      ContentServer
      Clan
      Chat
      P2PSuperSeeder
      AnonymousUser
    end

    enum Instance : UInt64
      All
      Desktop
      Console
      Web     = 4
    end

    TypeChar = {
      Type::Invalid             => "I",
      Type::Individual          => "U",
      Type::Multiseat           => "M",
      Type::Gameserver          => "G",
      Type::AnonymousGameServer => "A",
      Type::Pending             => "P",
      Type::ContentServer       => "C",
      Type::Clan                => "g",
      Type::Chat                => "T",
      Type::AnonymousUser       => "a",
    }

    AccountIDMask       = 0xFFFFFFFF_u64
    AccountInstanceMask = 0x000FFFFF_u64

    enum ChatInstanceFlags : UInt64
      Clan     = (AccountInstanceMask + 1) >> 1,
      Lobby    = (AccountInstanceMask + 1) >> 2,
      MMSLobby = (AccountInstanceMask + 1) >> 3
    end

    SteamID2Regex = /^STEAM_([0-5]):([0-1]):([0-9]+)$/
    SteamID3Regex = /^\[([a-zA-Z]):([0-5]):([0-9]+)(:[0-9]+)?\]$/

    property universe : Universe = Universe::Invalid
    property type : Type = Type::Invalid
    property instance : Instance = Instance::All
    property account_id : UInt64 = 0_u64

    def initialize(input : String = "")
      if input.empty?
        return
      end

      sid2_match = SteamID2Regex.match input
      sid3_match = SteamID3Regex.match input

      if sid2_match
        if sid2_match[1]? && sid2_match[1].to_u64 > 0
          @universe = Universe.new sid2_match[1].to_u64
        else
          @universe = Universe::Public
        end

        @type = Type::Individual
        @instance = Instance::Desktop
        @account_id = (sid2_match[3].to_i * 2 + sid2_match[2].to_i).to_u64
      elsif sid3_match
        type_char = sid3_match[1]
        @universe = Universe.new sid3_match[2].to_u64
        @account_id = sid3_match[3].to_u64

        if sid3_match[4]?
          @instance = Instance.new sid3_match[4].chars.last(sid3_match[4].size - 1).join.to_u64
        elsif type_char == "U"
          @instance = Instance::Desktop
        end

        case type_char
        when "c"
          @instance = Instance.new @instance.value | ChatInstanceFlags::Clan.value
          @type = Type::Chat
        when "L"
          @instance = Instance.new @instance.value | ChatInstanceFlags::Lobby.value
          @type = Type::Chat
        else
          @type = TypeChar.invert[type_char]? || Type::Invalid
        end
      elsif !input.to_u64?
        raise "Unrecognizable SteamID: #{input}"
      else
        num = input.to_u64

        @universe = Universe.new num >> 56
        @type = Type.new ((num >> 52) & 0xF)
        @instance = Instance.new ((num >> 32) & 0xFFFFF)
        @account_id = (num & 0xFFFFFFFF) >> 0
      end
    end

    def is_valid
      [
        @type <= Type::Invalid || @type > Type::AnonymousUser,
        @universe <= Universe::Invalid || @universe > Universe::Dev,
        @type == Type::Individual && (@account_id == 0 || @instance > Instance::Web),
        @type == Type::Clan && (@account_id == 0 || @instance != Instance::All),
        @type == Type::Gameserver && @account_id == 0,
      ].none?
    end

    # Check whether this chat SteamID is tied to a Steam group
    def is_group_chat
      [
        @type == Type::Chat,
        @instance & ChatInstanceFlags::Clan,
      ].every?
    end

    # Check whether this chat SteamID is tied to a Steam lobby
    def is_lobby_chat
      [
        @type == Type::Lobby,
        (@instance.value & ChatInstanceFlags::Lobby.value || @instance.value & ChatInstanceFlags::MMSLobby.value),
      ].every?
    end

    def to_sid2(newFormat : Bool = false)
      if @type != Type::Individual
        raise "Not allowed to render Steam2ID for non-individual ID"
      end

      if !newFormat && @universe == Universe::Public
        @universe = Universe::Invalid
      end

      return "STEAM_#{@universe.value}:#{@account_id & 1}:#{@account_id / 2}"
    end

    def to_sid3
      type_char = TypeChar[@type]? || "i"

      if (@instance.value & ChatInstanceFlags::Clan.value) > 0
        type_char = "c"
      elsif (@instance.value & ChatInstanceFlags::Lobby.value) > 0
        type_char = "L"
      end

      instance = [
        @type == Type::AnonymousGameServer,
        @type == Type::Multiseat,
        @type == Type::Individual && @instance != Instance::Desktop,
      ].any? ? ":#{@instance.value}" : ""

      return "[#{type_char}:#{@universe.value}:#{@account_id}#{instance}]"
    end

    def to_sid64
      v1 = @account_id
      v2 = ((@universe.value << 24) | (@type.value << 20) | @instance.value).to_u64 << 32
      (v1 | v2).to_s
    end

    def ==(other : self)
      [
        self.universe == other.universe,
        self.type == other.type,
        self.instance == other.instance,
        self.account_id == other.account_id,
      ].all?
    end

    def self.from_individual_account_id(account_id : UInt64)
      sid = self.new

      sid.universe = Universe::Public
      sid.type = Type::Individual
      sid.instance = Instance::Desktop
      sid.account_id = account_id

      sid
    end
  end
end
