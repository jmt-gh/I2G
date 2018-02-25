module I2G
  module Converter
    class Dconf
      def initialize; end
      def convert(real_values)
        dconf_value = '#'

        rgb_values = convert_real_values_to_rgb(real_values)
        %w[Red Green Blue].each do |color|
          dconf_value << rgb_values["#{color} Component"] * 2
        end

        return dconf_value
      end

      private

      def convert_real_values_to_rgb(real_values)
        new_values = {}
        real_values.each do |color, value|
          new_values[color] = convert_real_to_rgb(value)
        end
        return new_values
      end

      def convert_real_to_rgb(real_value)
        return "%02X" % (real_value * 255)
      end
    end
  end
end
