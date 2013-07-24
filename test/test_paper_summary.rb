require 'test/unit'
require 'paper_summary'
require 'test_helper'

class PaperSummaryTest < Test::Unit::TestCase
  def test_elife_summary

    fluiddb_response = File.read(File.join(File.dirname(__FILE__), 'fluiddb.json'))
    
    stub_request(:any, /fluiddb.fluidinfo.com\/.*/).
      to_return(:body => fluiddb_response, :status => 200,  :headers => { 'Content-Length' => fluiddb_response.length })

    dx_doi = File.read(File.join(File.dirname(__FILE__), 'dx_doi.raw'))

    stub_request(:any, /dx.doi.org\/.*/).
      to_return(dx_doi)

    elife_lookup = File.read(File.join(File.dirname(__FILE__), 'elife_lookup.raw'))

    stub_request(:any, /elife.elifesciences.org\/lookup\/.*/).
      to_return(elife_lookup)

    elife_xml = File.read(File.join(File.dirname(__FILE__), 'elife.xml'))

    stub_request(:any, /elife.elifesciences.org\/content\/.*/).
      to_return(:body => elife_xml, :status => 200,  :headers => { 'Content-Length' => elife_xml.length })

    summary_text = PaperSummary.summary_for('doi:10.7554/eLife.00013')[:summary_text]
    assert summary_text =~ /^All animals, including humans, evolved in a world filled with bacteria./ 
    assert summary_text =~ /evolution of multicellularity in animals.DOI: http:\/\/dx.doi.org\/10.7554\/eLife.00013.002$/
      
  end

  def test_elife_summary_live
    WebMock.allow_net_connect!

    summary_text = PaperSummary.summary_for('doi:10.7554/eLife.00013')[:summary_text]
    assert summary_text =~ /^All animals, including humans, evolved in a world filled with bacteria./ 
    assert summary_text =~ /evolution of multicellularity in animals.DOI: http:\/\/dx.doi.org\/10.7554\/eLife.00013.002$/
      
    WebMock.disable_net_connect!
  end
end
