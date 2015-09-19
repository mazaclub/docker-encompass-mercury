import cryptocur

class Currency(cryptocur.CryptoCur):
    p2pkh_version = 36
    #pubkey_addr
    p2sh_version = 5
    # script_addr
    genesis_hash = '00000ac5927c594d49cc0bdb81759d0da8297eb614683d3acb62f0703b639023'

    coin_name = 'groestlcoin'
    code = 'grs'

    irc_channel = '#electrum-grs'
