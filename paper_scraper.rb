require 'open-uri'
require 'open_uri_redirections'

class String
  def extract_link
    temp_text = self[/#{Regexp.escape('FullText PDF')}(.*?)#{Regexp.escape('PDF')}/m, 1]
    temp_text[/#{Regexp.escape('href="')}(.*?)#{Regexp.escape('"')}/m, 1]
  end
end

if ARGV.length != 2
    puts "Wrong number of arguments."
    puts "Usage: ruby paper_scraper.rb <digital library> <paper id>"
    exit
else
    digitalLib = ARGV[0]
    paperId = ARGV[1]
end

paperId = '1950427'

if not digitalLib.eql? 'ACM' then
    p 'Only ACM Digital Library is currently supported.'
    exit
end

url = 'https://dl.acm.org/citation.cfm?id=' + paperId
p url

page = open(url, "User-Agent" => "COMPAS Lab Paper Scraper v0.1").read
p 'Page was successfully fetched.'

link = page.extract_link
p link
link = 'http://dl.acm.org/' + link
open('paper.pdf', 'wb') do |file|
    file << open(link, "User-Agent" => "COMPAS Lab Paper Scraper v0.1", :allow_redirections => :all).read
end
