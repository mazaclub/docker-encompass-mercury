import cryptocur

class Currency(cryptocur.CryptoCur):
    p2pkh_version = 52
    #pubkey_addr
    p2sh_version = 13
    # script_addr
    genesis_hash = '000000000062b72c5e2ceb45fbc8587e807c155b0da735e6483dfba2f0a9c770'

    coin_name = 'YOURcoin'
    code = 'XYZ'

    irc_channel = '#electrum-xyz'
