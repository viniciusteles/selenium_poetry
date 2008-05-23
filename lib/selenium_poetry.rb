# This module extends SeleniumOnRails::TestBuilder. It enables you to write more readable Selenium tests.
#
# To use the methods of Selenium Poetry in your tests, you'll first need to load selectors. Do that with the method load_selectors.
#
# Selector files must be place in your Rails application under the directory test/selectors. They should be YAML[http://www.ruby-doc.org/core/classes/YAML.html] files.
module SeleniumPoetry
  
  SELECTORS_DIR = File.dirname(__FILE__) + "/../../../../test/selectors"
  
  # Use it load the selectors you'll need to use in your Selenium test. Example:
  # 
  #  load_selectors :index
  # 
  # This will load selectors from the file test/selectors/index.yml. 
  # If you have to load selectors from several files, you do like this:
  #
  #   load_selectors :index, :checkout, :finish
  # 
  # It will load selectors from the files:
  # 
  # * test/selectors/index.yml
  # * test/selectors/checkout.yml
  # * test/selectors/finish.yml
  #
  # Place load_selectors in the beginning of your tests.
  def load_selectors(*filenames)
    @selectors ||= {}
    filenames.each { |filename| @selectors.merge!(YAML::load(File.read(SELECTORS_DIR + "/#{filename.to_s}.yml"))) }
  end
  
  # Is equivalent to Selenium's <tt>assert_element_present</tt>. 
  #
  # Suppose you have the selector file test/selectors/index.yml with this content:
  #
  #   postcard of rio de janeiro:
  #       //ul/li/img[@src="images/riodejaneiro.jpg" and @alt="Rio de Janeiro" and @title="Rio de Janeiro"]
  #   postcard of recife:
  #       //ul/li/img[@src="images/recife.jpg" and @alt="Recife" and @title="Recife"]
  #
  # Using should_have: 
  #
  #   should_have "postcard of rio de janeiro"
  #
  # This is equivalent to the regular Selenium command:
  #
  #   assert_element_present '//ul/li/img[@src="images/riodejaneiro.jpg" and @alt="Rio de Janeiro" and @title="Rio de Janeiro"]'
  #
  # If you need to test more than one selector, use this syntax:
  #
  #   should_have "postcard of rio de janeiro", 
  #               "postcard of recife"
  #
  # This will produce the equivalent Selenium commands:
  #
  #   assert_element_present '//ul/li/img[@src="images/riodejaneiro.jpg" and @alt="Rio de Janeiro" and @title="Rio de Janeiro"]'
  #   assert_element_present '//ul/li/img[@src="images/recife.jpg" and @alt="Recife" and @title="Recife"]'
  def should_have(*selector_keys)
    run_protected do
      selector_keys.each { |key| assert_element_present @selectors[key] } 
    end
  end
  
  # Is equivalent to Selenium's <tt>assert_element_not_present</tt>. 
  # 
  # Take a look at should_have for further explanation.
  def should_not_have(*selector_keys)
    run_protected do
      selector_keys.each { |key| assert_element_not_present @selectors[key] } 
    end
  end
  
  # Is equivalent to Selenium's <tt>wait_for_element_present</tt>. 
  #
  # Take a look at should_have for further explanation. It's the same thing, but uses <tt>wait_for_element_present</tt> instead of <tt>assert_element_present</tt>.
  def should_wait_for(*selector_keys)
    run_protected do
      selector_keys.each { |key| wait_for_element_present @selectors[key] } 
    end
  end
  
  # Is equivalent to Selenium's <tt>wait_for_element_not_present</tt>. 
  # 
  # Take a look at should_not_have for further explanation. It's the same thing, but uses <tt>wait_for_element_not_present</tt> instead of <tt>assert_element_present</tt>.
  def should_wait_for_absence_of(*selector_keys)
    run_protected do
      selector_keys.each { |key| wait_for_element_not_present @selectors[key] } 
    end
  end
  
  # Is equivalent to Selenium's <tt>click</tt>. 
  #
  # Suppose you have the selector file test/selectors/index.yml with this content:
  #
  #   buy button:
  #       //a[@href="checkout.html" and text()="Buy"]
  #
  # Using click_on: 
  #
  #   click_on "buy button"
  #
  # This is equivalent to the regular Selenium command:
  #
  #   click '//a[@href="checkout.html" and text()="Buy"]'
  def click_on(*selector_keys)
    run_protected do
      selector_keys.each { |key| click @selectors[key] }
    end
  end

  # Is equivalent to Selenium's <tt>click_and_wait</tt>.  
  #
  # This is similar to click_on, except that instead of using Selenium's <tt>click</tt>, it uses <tt>click_and_wait</tt>.
  def click_on_and_wait(*selector_keys)
    run_protected do
      selector_keys.each { |key| click_and_wait @selectors[key] }
    end
  end
  
  # Is equivalent to Selenium's <tt>assert_eval</tt>.
  #
  # Suppose you have the selector file test/selectors/index.yml with this content:
  #
  #  number of postcards:    
  #     this.page().findElement('postcards').select('img').length;
  #  number of postcards selected:    
  #     this.page().findElement('selection').select('img').length;
  #
  # Using should_equal: 
  #
  #   should_equal          "number of postcards" => 4
  #
  # This is equivalent to the regular Selenium command:
  #
  #   assert_eval             "this.page().findElement('postcards').select('img').length;", 4
  #
  # If you need to test more than one selector, use this syntax:
  #
  #   should_equal          "number of postcards" => 4, 
  #                         "number of postcards selected" => 1
  #
  # This will produce the equivalent Selenium commands:
  #
  #   assert_eval             "this.page().findElement('postcards').select('img').length;", 4
  #   assert_eval             "this.page().findElement('selection').select('img').length;"
  def should_equal(selector_keys_and_expected_values)
    run_protected do
      selector_keys_and_expected_values.each { |key, expected_value| assert_eval @selectors[key], expected_value }
    end
  end

  # Is equivalent to Selenium's <tt>wait_for_eval</tt>.
  #
  # This is similar to should_equal, except that instead of using Selenium's <tt>assert_eval</tt>, it uses <tt>wait_for_eval</tt>.
  def should_wait_for_equal(script_expected)
    run_protected do
      script_expected.each { |script, expected| wait_for_eval @selectors[script], expected }
    end
  end
  
  # Is equivalent to Selenium's <tt>assert_text</tt>.
  #
  # Suppose you have the selector file test/selectors/index.yml with this content:
  #
  # page heading:
  #     //h1
  #
  # Using should_have: 
  #
  #   should_have_text  "page heading", "Postcard Gallery"
  #
  # This is equivalent to the regular Selenium command:
  #
  #   assert_text            "//h1", "Postcard Gallery"
  #
  def should_have_text(key, text)
    run_protected do
      assert_text @selectors[key], text
    end
  end

  # Is equivalent to Selenium's <tt>assert_eval somethind, true</tt>.
  #
  # Suppose you have the selector file test/selectors/index.yml with this content:
  #
  #   empty selection area:
  #      this.page().findElement('selection').select('img').length == 0;
  #
  #   less postcards after drag:
  #      this.page().findElement('selection').select('img').length < numberOfPostarcdsAvaliable;
  #
  # Using should_be: 
  #
  #   should_be             "empty selection area"  
  #
  # This is equivalent to the regular Selenium command:
  #
  #   assert_eval             "this.page().findElement('selection').select('img').length == 0;", true 
  #
  # If you need to test more than one selector, use this syntax:
  #
  #   should_be             "empty selection area",
  #                         "less postcards after drag"
  #
  # This will produce the equivalent Selenium commands:
  #
  #   assert_eval             "this.page().findElement('selection').select('img').length == 0;", true                 
  #   assert_eval             "this.page().findElement('selection').select('img').length < numberOfPostarcdsAvaliable;", true
  def should_be(*selector_keys)
    run_protected do
      selector_keys.each { |key| assert_eval @selectors[key], true }
    end
  end

  # Is equivalent to Selenium's <tt>assert_eval somethind, false</tt>.
  #
  # This is similar to should_be, except that instead of using true, it uses false.
  def should_not_be(*selector_keys)
    run_protected do
      selector_keys.each { |key| assert_eval @selectors[key], false }
    end
  end
  
  # Is equivalent to Selenium's <tt>store_eval</tt>.  
  #
  # Suppose you have the selector file test/selectors/index.yml with this content:
  #
  #   number of postcards:    
  #      this.page().findElement('postcards').select('img').length;
  #
  # Using should_store: 
  #
  #   should_store          "number of postcards" => "numberOfPostarcdsAvaliable"
  #
  # This is equivalent to the regular Selenium command:
  #
  #   store_eval            "this.page().findElement('postcards').select('img').length;", "numberOfPostarcdsAvaliable"
  #
  def should_store(script_variable)
    run_protected do 
      script_variable.each { |script, variable| store_eval @selectors[script], variable }
    end
  end
  
  # Is equivalent to Selenium's <tt>type</tt>.  
  #
  # Suppose you have the selector file test/selectors/checkout.yml with this content:
  #
  # input for name:
  #     //form/fieldset/input[@name="name" and @type="text"]
  # 
  # input for email:
  #     //form/fieldset/input[@name="email" and @type="text"]
  #
  # Using type_on: 
  #
  #   type_on                     "input for name"    => "Steve Jobs",
  #                               "input for email"   => "rdf@apple.com",
  #
  # This is equivalent to the regular Selenium command:
  #
  #   type                         '//form/fieldset/input[@name="name" and @type="text"]',    'Steve Jobs'
  #   type                         '//form/fieldset/input[@name="email" and @type="text"]',   'rdf@apple.com'
  #
  def type_on(selector_keys_and_expected_values)
    run_protected do
      selector_keys_and_expected_values.each { |key, expected_value| type @selectors[key], expected_value }
    end
  end
  
  # Is equivalent to Selenium's <tt>drag_and_drop_to_object</tt>.
  #
  # Suppose you have the selector file test/selectors/index.yml with this content:
  #
  # postcard of rio de janeiro:
  #    //ul/li/img[@src="images/riodejaneiro.jpg" and @alt="Rio de Janeiro" and @title="Rio de Janeiro"]
  # 
  #  selection area:
  #   //div[@id="selection"]
  #
  # Using should_drag_and_drop: 
  #
  #   should_drag_and_drop  "postcard of rio de janeiro", "selection area"
  #
  # This is equivalent to the regular Selenium command:
  #
  #   drag_and_drop_to_object '//ul/li/img[@src="images/riodejaneiro.jpg" and @alt="Rio de Janeiro" and @title="Rio de Janeiro"]', '//div[@id="selection"]'
  #  
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