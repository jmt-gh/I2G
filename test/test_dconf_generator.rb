require_relative 'test_helper.rb'

class TestDconfGenerator < Minitest::Test
  def setup
    theme_file = './test/Molokai.itermcolors'

    @parser = I2G::Parser::Plist.new(I2G::Converter::Dconf.new)
    @parser.load_theme(theme_file)

    @dconf = I2G::Generator::Dconf.new(@parser)
  end

  def teardown
    f = './test/Molokai.dconf'
    File.delete(f) if File.exists?(f)
  end

  def test_it_is_a_dconf_generator
    assert_kind_of I2G::Generator::Dconf, @dconf
  end

  def test_it_can_convert_iterm2_to_gnome
    expected = read('./test/Molokai-expected-generated-theme.dconf')

    @dconf.generate_theme(theme_name: 'Molokai',
                          output_directory: './test/',
                          uuid: '9d64d629-72b9-40c3-a41e-832faa24af0c')

    actual = read('./test/Molokai.dconf')


    assert_equal expected, actual
  end

  def test_it_can_convert_a_theme_with_no_uuid_override
    expected = read('./test/Molokai-expected-generated-theme.dconf')

    @dconf.generate_theme(theme_name: 'Molokai',
                          output_directory: './test/')

    actual = read('./test/Molokai.dconf')


    refute_same expected, actual
  end

  def test_it_can_create_a_palette
    expected = "['#121212121212', '#FAFA25257373', '#9797E1E12323', '#DFDFD4D46060', " + \
               "'#0F0F7F7FCFCF', '#87870000FFFF', '#4242A7A7CFCF', '#BBBBBBBBBBBB', " + \
               "'#555555555555', '#F5F566669C9C', '#B0B0E0E05E5E', '#FEFEF2F26C6C', " + \
               "'#0000AFAFFFFF', '#AFAF8787FFFF', '#5050CDCDFEFE', '#FFFFFFFFFFFF']"
    assert_equal expected, @dconf.palette
  end

  def test_it_responds_to_parser
    assert_respond_to @dconf, :parser
  end

  private

  def read(path)
    File.read(path)
  end
end
