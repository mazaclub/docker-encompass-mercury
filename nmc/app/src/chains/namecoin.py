import cryptocur

class Currency(cryptocur.CryptoCur):
    p2pkh_version = 52
    p2sh_version = 13
    genesis_hash = '000000000062b72c5e2ceb45fbc8587e807c155b0da735e6483dfba2f0a9c770'

    coin_name = 'Namecoin'
    code = 'NMC'
    irc_nick_prefix = 'EM_nmc_'
    irc_channel = '#electrum-nmc'
