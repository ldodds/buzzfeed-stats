require "csv"

numbers = []
listicles = []
count = 0
CSV.foreach(ARGV[0], "r") do |row|
  date, url, title, description = row
  #ignore japanese language titles as I don't know how to handle them!
  next if url.match(/\/jp\//)
  count = count + 1
  match = title.match(/^(The)? ?([0-9]{1,3} )/)
  if match
    listicles << { number: match[2].to_i, date: date, url: url, title: title, description: description}
    numbers << match[2].to_i
  end
end

CSV.open("listicles_by_date.csv", "w") do |csv|
    csv << ["Date", "Number", "Title", "URL"]
    listicles.sort_by {|k,v| k[:date]}.each do |article|
      csv << [ article[:date], article[:number], article[:title], article[:url],  ]
    end
end

CSV.open("listicles_by_number.csv", "w") do |csv|
    csv << ["Number", "Title", "URL"]
    listicles.sort_by {|k,v| k[:number]}.each do |article|
      csv << [ article[:number], article[:title], article[:url] ]
    end
end

puts "Minimum: #{numbers.min}"	
puts "Maximum: #{numbers.max}"
total = numbers.inject(:+)
puts "Listicles: #{numbers.length}"
puts "Articles: #{count}"
puts "Average: #{total.to_f / numbers.length }"
sorted = numbers.sort
median = numbers.length % 2 == 1 ? sorted[numbers.length/2] : (sorted[numbers.length/2 - 1] + sorted[numbers.length/2]).to_f / 2
puts "Median: #{median}"

