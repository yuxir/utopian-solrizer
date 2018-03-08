require 'utopian_ruby_api'
require 'rsolr'

module UtopianSolrizer
  
  class << self
    # define utopian solr fileds by following solr dynamic fields conventions
    @@fields = {
      "id"         => "id",
      "author"     => "author_ssi",
      "moderator"  => "moderator_ssim",
      "permlink"   => "permlink_ssi",
      "category"   => "category_ssi",
      "tags"       => "tags_ssim",
      "title"      => "title_tsim",
      "body"       => "body_tsim",
      "repository" => "repository_ssi"
    }

    
    # Add/update a post in solr
    def solrize_post(post, solr_options, overwrite=true)
      rsolr = RSolr.connect solr_options
      if (overwrite==true) or (not exist(solr_options, post.id))
        rsolr.add(
          @@fields["id"]         => post.id,
          @@fields["author"]     => post.author,
          @@fields["moderator"]  => post.moderator,
          @@fields["permlink"]   => post.permlink,
          @@fields["category"]   => post.json_metadata['type'],
          @@fields["tags"]       => post.json_metadata['tags'],
          @@fields["title"]      => post.title,
          @@fields["body"]       => post.body,
          @@fields["repository"] => post.json_metadata['repository']['html_url']
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
