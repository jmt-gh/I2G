module I2G
  module Generator
    class Dconf
      attr_reader :parser
      def initialize(parser)
        @parser = parser
      end

      def generate_theme(theme_name:, output_directory: 'generated-themes', uuid: '')
        generated_uuid = uuid.empty? ? generate_uuid : uuid

        open("#{output_directory}/#{theme_name}.dconf", 'w') do |text|
          text << "[:#{generated_uuid}]\n"
          text << "foreground-color='#{parser.foreground_color}'\n"
          text << "visible-name='#{theme_name}'\n"
          text << "palette=#{palette}\n"
          text << "use-system-font=false\n"
          text << "use-theme-colors=false\n"
          text << "font='Ubuntu Mono 12'\n"
          text << "use-theme-background=false\n"
          text << "background-color='#{parser.background_color}'\n"
        end
      end

      def palette
        list_of_values = []
        16.times do |number|
          parser.send("ansi_#{number}_color")
          list_of_values << parser.send("ansi_#{number}_color")
        end

        list_of_values.to_s.tr('"', '\'')
      end

      private

      def generate_uuid
        `uuidgen`
      end
    end
  end
end
