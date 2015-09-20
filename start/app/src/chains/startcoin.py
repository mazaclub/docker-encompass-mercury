import cryptocur
 
class Currency(cryptocur.CryptoCur):
        p2pkh_version = 125
        p2sh_version = 5
        genesis_hash = '00000bb6b5dcf5e81dee7f18ebd51055228d5fb3e41cc62f4034488f8eaf4448'
 
        coin_name = 'StartCOIN'
        code = 'START'
        irc_nick_prefix = 'EM_start_'
        irc_channel = '#electrum-start'
      
