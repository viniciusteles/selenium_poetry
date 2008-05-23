puts File.expand_path(File.dirname(__FILE__))

task :generate_doc do
  plugin_path = File.expand_path(File.dirname(__FILE__) + "/..")
  bin_path = "#{plugin_path}/bin"
  doc_path = "#{plugin_path}/doc"
  sh "chmod +x #{bin_path}/bluecloth"
  sh "#{bin_path}/bluecloth #{doc_path}/tutorial/tutorial.text > #{doc_path}/tutorial/tutorial.html"
  
  index = File.read("#{doc_path}/tutorial/tutorial.html")
  
  File.open("#{doc_path}/tutorial/tutorial.html", 'w+') do |index_file|
    index_file << index
  end
  
end
