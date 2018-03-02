module I2G
  module Converter
    class Iterm2ToDconf
      def initialize; end

      def convert(real_values)
        dconf_value = '#'
        %w[Red Green Blue].each do |color|
          dconf_value << convert_real_to_rgb(real_values["#{color} Component"]) * 2
        end

        dconf_value
      end

      private

      def convert_real_to_rgb(real_value)
        format('%02X', (real_value * 255))
      end
    end
  end
end
