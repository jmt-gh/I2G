require 'shellwords'
module I2G
  module Installer
    class Dconf
      def self.install_theme(theme_path)
        theme = File.read(theme_path)
        uuid = clean_uuid(theme)
        create_new_profile(uuid)
        install_new_profile(theme_path)
      end

      private

      private_class_method def self.create_new_profile(uuid)
        current_profile_list = DconfSystemCalls.read('list')
        if current_profile_list.empty?
          new_profile_list = "['#{uuid}']"
        else
          new_profile_list = current_profile_list.gsub(/(?<=')(?=\])/, ", '#{uuid}'")
        end
        puts "Creating new profile with UUID: #{uuid}"
        puts new_profile_list
        DconfSystemCalls.write('list', new_profile_list)
      end

      # creating a new profile doesn't actually make it accessible to select
      # so we need to explicitly install (load) it
      private_class_method def self.install_new_profile(theme_path)
        DconfSystemCalls.load(theme_path)
      end

      private_class_method def self.clean_uuid(uuid)
        uuid = uuid.split("\n").first
        uuid[0..1] = ''
        uuid[-1] = ''
        uuid
      end
    end

    class DconfSystemCalls
      GNOME_TERMINAL_PATH = '/org/gnome/terminal/legacy/profiles:'.freeze
      def self.read(endpoint)
        puts "Reading #{endpoint}"
        `dconf read #{GNOME_TERMINAL_PATH}/#{endpoint}`
      end

      def self.write(endpoint, value)
        puts "Writing #{endpoint} with #{value}"
        `dconf write #{GNOME_TERMINAL_PATH}/#{endpoint} "#{value}"`
      end

      def self.load(value)
        puts "Loading #{GNOME_TERMINAL_PATH} with #{Shellwords.shellescape(value)}"
        `dconf load #{GNOME_TERMINAL_PATH}/ < #{Shellwords.shellescape(value)}`
      end
    end
  end
end
