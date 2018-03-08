require 'spec_helper'

describe UtopianSolrizer do
  @@solr_options = { read_timeout: 120, open_timeout: 120, url: 'http://localhost:8983/solr/utopian' }

  it "has solrize_post" do
    post = UtopianRuby::UtopianRubyAPI.get_post_obj('yuxi','utopian-api-ruby-client')
    response = UtopianSolrizer.solrize_post(post, @@solr_options)
    expect(response['responseHeader']['status']).to eq(0)
  end

  it "has query" do
    params = { :q => "*:*" }
    response = UtopianSolrizer.query(@@solr_options, params)
    expect(response['responseHeader']['status']).to eq(0)
    #response["response"]["docs"].each do |d|
    #  puts d["id"]
    #  puts d["author"]
    #end
  end

  it "has exist method" do
    id = '0'
    expect(UtopianSolrizer.exist(@@solr_options, id)).to eq(false)
  end
end
