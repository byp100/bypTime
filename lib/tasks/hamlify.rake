require 'html2haml/html'

namespace :hamlify do
  desc "Convert ERB to Haml"
  task :convert => :environment do

    #Cycles through views folder and searches for erb files
    Dir["#{Rails.root}/app/views/**/*.erb"].each do |filename|

      puts "Hamlifying: #{filename}"

      #Creates a new file path for the haml to be exported to
      haml_filename = filename.gsub(/erb$/, "haml")

      #If haml is missing, create it and get rid of the erb
      if !File.exist?(haml_filename)

        #Reads erb from file
        erb_string = File.open(filename).read

        #Converts erb to haml
        haml_string = Html2haml::HTML.new(erb_string, :erb => true).render

        #Writes the haml
        file = File.new(haml_filename, "w")
        file.write(haml_string)

        #Gets rid of the erb
        File.delete(filename)
      end
    end
  end
end