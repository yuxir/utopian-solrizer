require 'utopian_ruby_api'
require 'rsolr'

module UtopianSolrizer
  
  class << self
    
    # Add posts to solr
    def solrize_post(post, solr_options)
      rsolr = RSolr.connect solr_options
      rsolr.add(
        :author    => post.author,
        :moderator => post.moderator,
        :permlink  => post.permlink,
        :category  => post.category,
        :title     => post.title,
        :body      => post.body
      )
    end

    # Add posts by criterias
    def solrize_posts_by_criterias(criterias, solr_options)
      UtopianRuby::UtopianRubyAPI.get_posts_obj(criterias).each do |post|
        solrize_post(post, solr_options)
      end
    end


    # Add approved posts 
    def solrize_approved_posts_by_category(category, solr_options)
   
    end

    def query(solr_options, params)
      rsolr = RSolr.connect solr_options
      response = rsolr.select :params => params
    end

  end
  
end
