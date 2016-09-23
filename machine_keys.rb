require 'socket'

class MachineKeys

  # on mac, type hostname in terminal
  def machine_keys
    {
        ian:  	['F3M3s-MacBook-Air.local', 'f3m3s-air.home', 'f3m3s-air', 'F3M3sMA.local', 'f3m3sma'],
        ian_w:  ['OE2021.local'],
        dad: 	  ['John'],
        john:   ['Johns-Mac-mini.home']
    }
  end

  def get_machine_key
    machine_keys.each { |key, value| return key if value.include?(Socket.gethostname) }
  end

  def get_rel_path
    {
        ian: 	  '../../../../Applications/MAMP/bin/mamp/Dropbox/',
        ian_w:  '../../../ian/accounts/',
        dad: 	  '../../Users/John/Dropbox/',
        john:   '../../Dropbox/'
    }[machine_key]
  end
 end