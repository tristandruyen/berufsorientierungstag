require 'json'

class Config
  def self.config_hash
    config_file = 'settings.ini'
    if File.file?(config_file)
      file = File.read(config_file)
      return JSON.parse(file)['settings']
    else
        {
          'computer_number' => '0',
          'first_name' => 'NA',
          'last_name' => 'NA',
          'email' => 'NA'
        }
    end
  end
end
