require 'paper_summary/version'
require 'nokogiri'
require 'net/http'
require 'open-uri'
require 'cgi'
require 'uri'
require 'json'
require 'pry'

module PaperSummary
  class << self

    def summary_for(identifier)
      if identifier =~ /^arxiv\:(.*)/i
        nil # summary_for_arxiv($1.strip)
      elsif identifier =~ /^doi\:\s*(10\.7554\/.*)/i
        summary_for_elife($1.strip)
      elsif identifier =~ /^doi\:(.*)/i
        nil
      end
    end

    def summary_for_elife(doi)
      fluiddb = JSON.parse(open("http://fluiddb.fluidinfo.com/values?query=elifesciences.org/api_v1/article/doi=%22#{doi}%22&tag=*").read)

      # Get the DOI url
      doi = fluiddb['results']['id'].values.first['fluiddb/about']['value'].match(/doi\.org\/(.*)/)[1]
      
      # Get the eLife url
      url = URI.parse('http://dx.doi.org')
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.get("/#{doi}")
      }
      url = URI.parse(res['location'])
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.get(url.path)
      }
      elife_xml_url = res['location'] + '.source.xml'

      # Get the eLife paper XML
      xml = Nokogiri::XML(open(elife_xml_url)).css('abstract[abstract-type="executive-summary"] p')
      summary = {}
      summary[:summary_html] = xml.to_html
      summary[:summary_text] = xml.text
      summary
    end
  end
end
