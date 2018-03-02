require_relative 'test_helper.rb'

class TestIterm2Parser < Minitest::Test
  def setup
    @pl = I2G::Parser::Iterm2.new(I2G::Converter::Dconf.new)

    theme_path = './test/Molokai.itermcolors'
    @pl.load_theme(theme_path)
  end

  def test_it_is_an_iterm2_parser
    assert_kind_of I2G::Parser::Iterm2, @pl
  end

  def test_it_can_load_in_theme
    assert_kind_of Hash, @pl.current_theme
  end

  def test_it_can_return_ansi_1_color_as_dconf_value
    assert_equal '#FAFA25257373', @pl.ansi_1_color
  end

  def test_it_can_load_a_theme_with_color_space_definition
    color_space_theme_path = './test/Hacktober.itermcolors'
    @pl.load_theme(color_space_theme_path)

    assert_kind_of Hash, @pl.current_theme
  end

  def test_it_can_load_a_theme_with_alpha_definition
    alpha_theme_path = './test/Violet Light.itermcolors'
    @pl.load_theme(alpha_theme_path)

    assert_kind_of Hash, @pl.current_theme
  end

  16.times do |number|
    class_eval <<-METHOD, __FILE__, __LINE__ + 1
      def test_it_responds_to_ansi_#{number}_color
        assert_respond_to @pl, :ansi_#{number}_color
      end
    METHOD
  end

  %w[background bold cursor cursor_text selected_text selection].each do |word|
    class_eval <<-METHOD, __FILE__, __LINE__ + 1
      def test_it_responds_to_#{word}
        assert_respond_to @pl, :#{word}_color
      end
    METHOD
  end
end
