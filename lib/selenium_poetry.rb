module SeleniumPoetry
  
  SELECTORS_DIR = File.dirname(__FILE__) + "/../../../../test/selectors"
  
  def load_selectors(*filenames)
    @selectors ||= {}
    filenames.each { |filename| @selectors.merge!(YAML::load(File.read(SELECTORS_DIR + "/#{filename.to_s}.yml"))) }
  end
  
  def should_have(*selector_keys)
    run_protected do
      selector_keys.each { |key| assert_element_present @selectors[key] } 
    end
  end
  
  def should_not_have(*selector_keys)
    run_protected do
      selector_keys.each { |key| assert_element_not_present @selectors[key] } 
    end
  end
  
  def should_wait_for(*selector_keys)
    run_protected do
      selector_keys.each { |key| wait_for_element_present @selectors[key] } 
    end
  end
  
  def should_wait_for_absence_of(*selector_keys)
    run_protected do
      selector_keys.each { |key| wait_for_element_not_present @selectors[key] } 
    end
  end
  
  def click_on(*selector_keys)
    run_protected do
      selector_keys.each { |key| click @selectors[key] }
    end
  end
  
  def click_on_and_wait(*selector_keys)
    run_protected do
      selector_keys.each { |key| click_and_wait @selectors[key] }
    end
  end
  
  def should_equal(selector_keys_and_expected_values)
    run_protected do
      selector_keys_and_expected_values.each { |key, expected_value| assert_eval @selectors[key], expected_value }
    end
  end

  def should_wait_for_equal(script_expected)
    run_protected do
      script_expected.each { |script, expected| wait_for_eval @selectors[script], expected }
    end
  end
  
  def should_have_text(key, text)
    run_protected do
      assert_text @selectors[key], text
    end
  end

  def should_be(*selector_keys)
    run_protected do
      selector_keys.each { |key| assert_eval @selectors[key], true }
    end
  end
  
  def should_not_be(*selector_keys)
    run_protected do
      selector_keys.each { |key| assert_eval @selectors[key], false }
    end
  end
  
  def should_store(script_variable)
    run_protected do 
      script_variable.each { |script, variable| store_eval @selectors[script], variable }
    end
  end
  
  def type_on(selector_keys_and_expected_values)
    run_protected do
      selector_keys_and_expected_values.each { |key, expected_value| type @selectors[key], expected_value }
    end
  end
  
  def should_drag_and_drop(key_of_origin, key_of_target)
    run_protected do
      drag_and_drop_to_object @selectors[key_of_origin], @selectors[key_of_target]
    end
  end
  
  private
  
  def run_protected
    if @selectors
      yield
    else
      raise ArgumentError, 'No selectors loaded!'
    end
  end
  
end