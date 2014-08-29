unless Rails.env.production?
  CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]
  ENV['ADMIN_USER'] = CONFIG['ADMIN_USER']
  ENV['ADMIN_PASSWORD'] = CONFIG['ADMIN_PASSWORD']
end