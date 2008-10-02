$: << File.dirname(__FILE__) + '/..' << File.dirname(__FILE__) + '/../lib'
%w(test/unit rubygems init yaml mocha stubba lib/selenium_poetry).each { |lib| require lib }

class SeleniumPoetryTest < Test::Unit::TestCase

  SELECTORS = { "address field"           => "//input[@id='address']",
                "login field"             => "//input[id='login']",
                "logo image"              => "//img[@src='logo.gif']", 
                "number of photos"        => "this.page().findElement('photos').select('a').length;",
                "number of addresses"     => "this.page().findElement('address').length;",
                "photos container empty"  => "this.page().findElement('photos').select('a').length == 0;", 
                "photos container full"   => "this.page().findElement('photos').select('a').length >= 30;",
                "checkout form"           => "//form" }

  include SeleniumPoetry

  def setup
    @selectors = SELECTORS
  end
  
  # load_selectors
  def test_load_selectors_when_no_filename_is_given
    @selectors = nil
    load_selectors
    assert_equal({}, @selectors)
  end

  def test_load_selectors_when_one_filename_is_given
    @selectors = nil
    expected_selector = { "address field" => "//input[@id='address']" }
    
    file_mock = mock('File')
    YAML.expects(:load).with(file_mock).returns(expected_selector)
    File.expects(:read).with(SELECTORS_DIR + "/contact_form.yml").returns(file_mock)
    
    load_selectors(:contact_form)
    assert_equal(expected_selector, @selectors)
  end

  def test_load_selectors_when_many_filenames_are_given
    @selectors = nil
    contact_file_mock = mock('File')
    homepage_file_mock = mock('File')
    YAML.expects(:load).with(contact_file_mock).returns({ "address field"            => "//input[@id='address']" })
    YAML.expects(:load).with(homepage_file_mock).returns({ "login field"             => "//input[id='login']",
                                                           "logo image"              => "//img[@src='logo.gif']", 
                                                           "number of photos"         => "this.page().findElement('photos').select('a').length;",
                                                           "number of addresses"     => "this.page().findElement('address').length;",
                                                           "photos container empty"  => "this.page().findElement('photos').select('a').length == 0;" , 
                                                           "photos container full"   => "this.page().findElement('photos').select('a').length >= 30;", 
                                                           "checkout form"           => "//form" })
    File.expects(:read).with(SELECTORS_DIR + "/contact_form.yml").returns(contact_file_mock)
    File.expects(:read).with(SELECTORS_DIR + "/homepage.yml").returns(homepage_file_mock)
    
    load_selectors(:contact_form, :homepage)
    assert_equal(SELECTORS, @selectors)
  end

  # should_have
  def test_should_have_when_no_selector_key_is_given
    verify_method_when_no_selector_key_is_given(:should_have, :assert_element_present)
  end
  
  def test_should_have_when_only_one_selector_key_is_given
    verify_method_when_only_one_selector_key_is_given(:should_have, :assert_element_present)
  end
  
  def test_should_have_when_two_selector_keys_are_given
    verify_method_when_two_selector_keys_are_given(:should_have, :assert_element_present)
  end
  
  def test_should_have_when_selectors_are_not_defined
    verify_method_when_selectors_are_not_defined :should_have
  end

  # should_not_have
  def test_should_not_have_when_no_selector_key_is_given
    verify_method_when_no_selector_key_is_given(:should_not_have, :assert_element_not_present)
  end
  
  def test_should_not_have_when_only_one_selector_key_is_given
    verify_method_when_only_one_selector_key_is_given(:should_not_have, :assert_element_not_present)
  end
  
  def test_should_not_have_when_two_selector_keys_are_given
    verify_method_when_two_selector_keys_are_given(:should_not_have, :assert_element_not_present)
  end
  
  def test_should_not_have_when_selectors_are_not_defined
    verify_method_when_selectors_are_not_defined :should_not_have
  end
  
  # should_wait_for
  def test_should_wait_for_when_no_selector_key_is_given
    verify_method_when_no_selector_key_is_given(:should_wait_for, :wait_for_element_present)
  end
  
  def test_should_wait_for_when_only_one_selector_key_is_given
    verify_method_when_only_one_selector_key_is_given(:should_wait_for, :wait_for_element_present)
  end
  
  def test_should_wait_for_when_two_selector_keys_are_given
    verify_method_when_two_selector_keys_are_given(:should_wait_for, :wait_for_element_present)
  end
  
  def test_should_wait_for_when_selectors_are_not_defined
    verify_method_when_selectors_are_not_defined :should_wait_for
  end
  
  # should_wait_for_absence_of
  def test_should_wait_for_absence_of_when_no_selector_key_is_given
    verify_method_when_no_selector_key_is_given(:should_wait_for_absence_of, :wait_for_element_not_present)
  end
  
  def test_should_wait_for_absence_of_when_only_one_selector_key_is_given
    verify_method_when_only_one_selector_key_is_given(:should_wait_for_absence_of, :wait_for_element_not_present)
  end
  
  def test_should_wait_for_absence_of_when_two_selector_keys_are_given
    verify_method_when_two_selector_keys_are_given(:should_wait_for_absence_of, :wait_for_element_not_present)
  end
  
  def test_should_wait_for_absence_of_when_selectors_are_not_defined
    verify_method_when_selectors_are_not_defined :should_wait_for_absence_of
  end
  
  # click_on
  def test_click_on_when_no_selector_key_is_given
    verify_method_when_no_selector_key_is_given(:click_on, :click)
  end
  
  def test_click_on_when_only_one_selector_key_is_given
    verify_method_when_only_one_selector_key_is_given(:click_on, :click)
  end
  
  def test_click_on_when_two_selector_keys_are_given
    verify_method_when_two_selector_keys_are_given(:click_on, :click)
  end
  
  def test_click_on_when_selectors_are_not_defined
    verify_method_when_selectors_are_not_defined :click_on
  end
  
  # click_on_and_wait
  def test_click_on_and_wait_when_no_selector_key_is_given
    verify_method_when_no_selector_key_is_given(:click_on_and_wait, :click_and_wait)
  end
  
  def test_click_on_and_wait_when_only_one_selector_key_is_given
    verify_method_when_only_one_selector_key_is_given(:click_on_and_wait, :click_and_wait)
  end
  
  def test_click_on_and_wait_when_two_selector_keys_are_given
    verify_method_when_two_selector_keys_are_given(:click_on_and_wait, :click_and_wait)
  end
  
  def test_click_on_and_wait_when_selectors_are_not_defined
    verify_method_when_selectors_are_not_defined :click_on_and_wait
  end
  
  # should_equal
  def test_should_equal_when_empty_hash_is_given
    expects(:assert_eval).never
    should_equal({})
  end

  def test_should_equal_when_only_one_verification_is_given
    expects(:assert_eval).with("this.page().findElement('photos').select('a').length;", 8)    
    should_equal "number of photos" => 8     
  end
  
  def test_should_equal_when_selectors_are_not_defined
    @selectors = nil
    assert_raise ArgumentError do
      should_equal({})
    end
  end
  
  # should_wait_for_equal
  def test_should_wait_for_equal_when_empty_hash_is_given
    expects(:wait_for_eval).never
    should_wait_for_equal({})
  end

  def test_should_wait_for_equal_when_only_one_verification_is_given
    expects(:wait_for_eval).with("this.page().findElement('photos').select('a').length;", 8)    
    should_wait_for_equal "number of photos" => 8     
  end
  
  def test_should_wait_for_equal_when_selectors_are_not_defined
    @selectors = nil
    assert_raise ArgumentError do
      should_wait_for_equal({})
    end
  end

  # should_have_text
  def test_should_have_text
    expects(:assert_text).with("//input[@id='address']", "500 Broadway")
    should_have_text "address field", "500 Broadway"
  end
  
  def test_should_have_text_when_selectors_are_not_defined
    @selectors = nil
    assert_raise ArgumentError do
      should_have_text(nil, nil)
    end
  end

  # should_be
  def test_should_be_when_empty_hash_is_given
    expects(:assert_eval).never
    should_be
  end
  
  def test_should_be_when_only_one_verification_is_given
    expects(:assert_eval).with("this.page().findElement('photos').select('a').length == 0;", true)
    should_be "photos container empty"
  end
  
  def test_should_be_when_two_verifications_are_given
    expects(:assert_eval).with("this.page().findElement('photos').select('a').length == 0;", true)
    expects(:assert_eval).with("this.page().findElement('photos').select('a').length >= 30;", true)
    should_be "photos container empty", 
              "photos container full"
  end

  def test_should_be_when_selectors_are_not_defined
    @selectors = nil
    assert_raise ArgumentError do
      should_be
    end
  end

  # should_not_be
  def test_should_not_be_when_empty_hash_is_given
    expects(:assert_eval).never
    should_not_be
  end
  
  def test_should_not_be_when_only_one_verification_is_given
    expects(:assert_eval).with("this.page().findElement('photos').select('a').length == 0;", false)
    should_not_be "photos container empty"
  end
  
  def test_should_not_be_when_two_verifications_are_given
    expects(:assert_eval).with("this.page().findElement('photos').select('a').length == 0;", false)
    expects(:assert_eval).with("this.page().findElement('photos').select('a').length >= 30;", false)
    should_not_be "photos container empty", 
                  "photos container full"
  end
  
  def test_should_not_be_when_selectors_are_not_defined
    @selectors = nil
    assert_raise ArgumentError do
      should_not_be
    end
  end

  # should_store
  def test_should_store_when_empty_hash_is_given
    expects(:store_eval).never
    should_store({})
  end

  def test_should_store_when_only_one_variable_is_given
    expects(:store_eval).with("this.page().findElement('photos').select('a').length;", "pagePhotos")    
    should_store "number of photos" => "pagePhotos"     
  end
  
  def test_should_store_when_two_variables_are_given
    expects(:store_eval).with("this.page().findElement('photos').select('a').length;", "photosCount")    
    expects(:store_eval).with("this.page().findElement('address').length;", "addressesCount")    
    should_store "number of photos"    => "photosCount",
                 "number of addresses" => "addressesCount"
  end

  def test_should_store_when_selectors_are_not_defined
    @selectors = nil
    assert_raise ArgumentError do
      should_store({})
    end
  end

  # type_on
  def test_type_on_when_empty_hash_is_given
    expects(:type).never
    type_on({})
  end
  
  def test_type_on_when_only_on_selector_key_is_given
    expects(:type).with("//input[@id='address']", "500 Broadway")
    type_on "address field" => "500 Broadway"
  end
  
  def test_type_on_when_two_selector_keys_are_given
    expects(:type).with("//input[@id='address']", "500 Broadway")
    expects(:type).with("//input[id='login']",    "beloved_user")
    type_on "address field" => "500 Broadway",
            "login field"   => "beloved_user"
  end

  def test_typo_on_when_selectors_are_not_defined
    @selectors = nil
    assert_raise ArgumentError do
      type_on({})
    end
  end

  # should_drag_and_drop
  def test_should_drag_and_drop
    expects(:drag_and_drop_to_object).with("//input[@id='address']", "//input[id='login']")
    should_drag_and_drop "address field", "login field"
  end
  
  def test_should_drag_and_drop_when_selectors_are_not_defined
    @selectors = nil
    assert_raise ArgumentError do
      should_drag_and_drop nil, nil
    end
  end

  # submit_on
  def test_submit_on
    expects(:submit).with("//form")
    submit_on "checkout form"
  end

  private
  
  def verify_method_when_no_selector_key_is_given(selenium_poetry_method, selenium_original_method)
    expects(selenium_original_method).never
    send selenium_poetry_method
  end

  def verify_method_when_only_one_selector_key_is_given(selenium_poetry_method, selenium_original_method)
    expects(selenium_original_method).with("//input[@id='address']")
    send selenium_poetry_method, "address field"
  end

  def verify_method_when_two_selector_keys_are_given(selenium_poetry_method, selenium_original_method)
    expects(selenium_original_method).with("//input[@id='address']")
    expects(selenium_original_method).with("//img[@src='logo.gif']")
    send selenium_poetry_method, "address field", "logo image"
  end

  def verify_method_when_selectors_are_not_defined(selenium_poetry_method)
    @selectors = nil
    assert_raise ArgumentError do
      send selenium_poetry_method
    end
  end

end
