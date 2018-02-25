require './lib/converters/dconf.rb'
require './lib/parsers/plist.rb'
require 'shellwords'

def dconf_read(endpoint)
  `dconf read #{GNOME_TERMINAL_PATH}/#{endpoint}`
end

def dconf_write(endpoint, value)
  `dconf write #{GNOME_TERMINAL_PATH}/#{endpoint} "#{value}"`
end

def dconf_load(value)
  `dconf load #{GNOME_TERMINAL_PATH}/ < #{Shellwords.shellescape(value)}`
end

def uuid
  `uuidgen`.chomp
end

def profile_list
  dconf_read('list')
end

def add_new_profile(generated_uuid)
  current_profile_list = profile_list
  if current_profile_list.empty?
    new_profile_list = "['#{generated_uuid}']"
  else
    new_profile_list = current_profile_list.gsub(/(?<=')(?=\])/, ", '#{generated_uuid}'")
  end

  puts "Creating new profile at UUID #{generated_uuid}"
  dconf_write('list', new_profile_list)
end

def generate_profile_file(name, generated_uuid, parser)
  open("gnome-themes/#{name}-theme-profile.dconf", 'w') do |text|
    text << "[:#{generated_uuid}]\n"
    text << "foreground-color='#{parser.foreground_color}'\n"
    text << "visible-name='#{name}'\n"
    text << "palette=#{palette(parser)}\n"
    text << "use-system-font=false\n"
    text << "use-theme-colors=false\n"
    text << "font='Ubuntu Mono 12'\n"
    text << "use-theme-background=false\n"
    text << "background-color='#{parser.background_color}'\n"
  end
end

def load_generated_profile(file_name)
  full_path = "gnome-themes/#{file_name}-theme-profile.dconf"
  dconf_load(full_path)
end

def palette(parser)
  list_of_values = []
  16.times do |number|
    parser.send("ansi_#{number}_color")
    list_of_values << parser.send("ansi_#{number}_color")
  end

  return list_of_values.to_s.gsub('"', '\'')
end

@pl = I2G::Parser::Plist.new(I2G::Converter::Dconf.new)
themes_to_convert = Dir.entries('iterm-themes/').select { |f| f.include?('.itermcolors') }
GNOME_TERMINAL_PATH = '/org/gnome/terminal/legacy/profiles:'.freeze

themes_to_convert.each do |theme|
  theme_name = theme.split('.itermcolors')[0]
  puts "theme name: #{theme_name}"
  @pl.load_theme("iterm-themes/#{theme}")
  generated_uuid = uuid
  generate_profile_file(theme_name, generated_uuid, @pl)
  puts "using #{generated_uuid}"
  load_generated_profile(theme_name)
  add_new_profile(generated_uuid)
end
