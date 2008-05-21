SeleniumOnRails::TestBuilder.send("include", SeleniumPoetry) if defined?(SeleniumOnRails::TestBuilder)

if defined?(SeleniumOnRails::TestBuilderActions)
  module SeleniumOnRails::TestBuilderActions
  
    alias_method :original_open, :open 

    def open(*urls)
      urls.each { |url| original_open url }
    end

  end
end
