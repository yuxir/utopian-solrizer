require 'spec_helper'

describe UtopianSolrizer do
  it "has solrizer_post" do
    post = UtopianRuby::UtopianRubyAPI.get_post_obj('espoem','old-moderated-posts-are-received-and-shown-instead-of-the-recent-one')
    solr_options = { read_timeout: 120, open_timeout: 120, url: 'http://localhost:8983/solr/utopian' }
    response = UtopianSolrizer.solrize_post(post, solr_options)
    puts response
  end

  it "has query" do
#    solr_options = { read_timeout: 120, open_timeout: 120, url: 'http://localhost:8983/solr/utopian' }
#    params = { :q => "espoem", :qf => "author_tesim" }
#    response = UtopianSolrizer.query(solr_options, params)
#    puts response
  end
end
