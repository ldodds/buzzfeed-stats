require "nokogiri"
require "csv"
require "open-uri"

doc = Nokogiri::HTML(open('http://www.buzzfeed.com/archive/2006/11'))

archives = []

$stderr.puts "Scanning for archives"

doc.search(".calendar__years a").each do |a|
	archives << "http://www.buzzfeed.com#{a["href"]}"
end

CSV.open(ARGV[0], "w") do |csv|
	csv << ["Date", "URL", "Title", "Description"]
	archives.each do |u|
	  begin
	      $stderr.puts "Parsing #{u}"
	      year, month = u.split("/")[-2..-1]
	      date = year + "-" + ("%02d" % month)
	      doc = Nokogiri::HTML(open(u))
	      doc.search("article").each do |article|
	         url = article.search("h2 a").first["href"]
	         title = article.search("h2").first.text.lstrip.rstrip
	         description = article.search("p").first.text.lstrip.rstrip
	         csv << [ date, url, title, description ] 
	      end      
      rescue => e
        puts e.message
        #puts e.backtrace
	  end
	end
end
