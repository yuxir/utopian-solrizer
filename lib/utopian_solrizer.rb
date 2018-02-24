require 'utopian_ruby_api'
require 'rsolr'

module UtopianSolrizer
  
  class << self
    
    # Add posts to solr
    def solrize_post(post, solr_options)
      rsolr = RSolr.connect solr_options
      if not exist(solr_options, post.id)
        rsolr.add(
          :id        => post.id,
          :author    => post.author,
          :moderator => post.moderator,
          :permlink  => post.permlink,
          :category  => post.category,
          :type      => post.json_metadata['type'],
          :tags      => post.json_metadata['tags'],
          :title     => post.title,
          :body      => post.body
        )
        rsolr.commit
      end
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

    # check if a solr document exists
    def exist(solr_options, id)
      params = { :q => 'id:'+id.to_s }
      puts params
      r = query(solr_options, params)
      if r["response"]["numFound"].to_i > 0
        return true
      end
      false
    end

    # delete solr document
    def delete(solr_options, id)
      if exist(solr_options, id)
        rsolr = RSolr.connect solr_options
        rsolr.delete_by_id(id)
        rsolr.commit
      end
    end

  end
  
end
