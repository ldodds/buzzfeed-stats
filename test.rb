require "nokogir"
require "open-uri"

doc = Nokogiri::HTML(open('http://www.buzzfeed.com/archive/2006/11'))

archives = []

$stderr.puts "Scanning for archives"

doc.search(".year a").each do |a|
  archives << "http://www.buzzfeed.com/#{a["href"]}"
end

pages = []
archives.each do |u|
  $stderr.puts "Parsing #{u}"
  doc = Nokogiri::HTML(open(u))
  doc.search(".flow a").each do |a|
     pages << {
       :url => "http://www.buzzfeed.com/#{a["href"]}",
       :title => a.children.text,
       :description => a["title"]       
     }
  end
end
