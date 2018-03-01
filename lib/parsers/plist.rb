require 'plist'
module I2G
  module Parser
    class Plist
      attr_reader :current_theme, :converter
      def initialize(converter)
        @converter = converter
      end

      def load_theme(theme_path)
        @current_theme = Plist::Plist.parse_xml(theme_path)
      end

      def theme_as_rgb
        %w[background bold cursor cursor_text selected_text selection].each do |word|
          puts send("#{word}_color")
        end
      end

      # ansi color methods
      16.times do |number|
        class_eval <<-METHOD, __FILE__, __LINE__ + 1
          def ansi_#{number}_color
            converter.convert(current_theme['Ansi #{number} Color'])
          end
        METHOD
      end

      def background_color
        converter.convert(current_theme['Background Color'])
      end

      def bold_color
        converter.convert(current_theme['Bold Color'])
      end

      def cursor_color
        converter.convert(current_theme['Cursor Color'])
      end

      def cursor_text_color
        converter.convert(current_theme['Cursor Text Color'])
      end

      def foreground_color
        converter.convert(current_theme['Foreground Color'])
      end

      def selected_text_color
        converter.convert(current_theme['Selected Text Color'])
      end

      def selection_color
        converter.convert(current_theme['Selection Color'])
      end
    end
  end
end
