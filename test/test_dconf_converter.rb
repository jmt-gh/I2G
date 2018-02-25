require_relative 'test_helper.rb'

class TestDconfConverter < Minitest::Test
  def setup
    @dconf = I2G::Converter::Dconf.new
  end

  def test_it_is_a_plist
    assert_kind_of I2G::Converter::Dconf, @dconf
  end

  def test_it_can_convert_real_values_to_dconf
    real_values = {"Blue Component"=>0.45098039507865906, "Green Component"=>0.14509804546833038, "Red Component"=>0.9803921580314636}
    expected_rgb = '#FAFA25257373'
    assert_equal expected_rgb, @dconf.convert(real_values)
  end

  def test_it_can_convert_real_values_with_color_space_definition_to_dconf
    real_values = {"Color Space"=> 'sRGB', "Blue Component"=>0.45098039507865906, "Green Component"=>0.14509804546833038, "Red Component"=>0.9803921580314636}
    expected_rgb = '#FAFA25257373'
    assert_equal expected_rgb, @dconf.convert(real_values)
  end

  def test_it_can_convert_real_values_alpha_definition_to_dconf
    real_values = {"Alpha Component"=> 1, "Blue Component"=>0.45098039507865906, "Green Component"=>0.14509804546833038, "Red Component"=>0.9803921580314636}
    expected_rgb = '#FAFA25257373'
    assert_equal expected_rgb, @dconf.convert(real_values)
  end

  def test_it_can_convert_real_values_with_color_space_definition_and_alpha_to_dconf
    real_values = {"Alpha Component"=> 1, "Color Space"=> 'sRGB', "Blue Component"=>0.45098039507865906, "Green Component"=>0.14509804546833038, "Red Component"=>0.9803921580314636}
    expected_rgb = '#FAFA25257373'
    assert_equal expected_rgb, @dconf.convert(real_values)
  end
end
