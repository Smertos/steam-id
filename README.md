# Steam ID

This library provides class `SteamID` which makes SteamID usage easy.
Basically, this is Crystal port of already existing [steamid](https://github.com/DoctorMcKay/node-steamid) NodeJS module.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  steam-id:
    github: Smertos/steam-id
```

## Usage

```crystal
require "steam-id"

sid = Steam::ID.new "STEAM_0:1:59569542"
sid3 = Steam::ID.new "[U:1:119139085]"
sid64 = Steam::ID.new "76561198079404813"
ind_sid = SteamID::ID.from_individual_account_id 46143802_u64

sid.to_sid2 # => "STEAM_0:1:59569542"
sid.to_sid3 # => "[U:1:119139085]"
sid.to_sid64 # => "76561198079404813"
```

## Contributing

1. Fork it ( https://github.com/[your-github-name]/steam-id/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [Mikhail Vedernikov](https://github.com/Smertos)
