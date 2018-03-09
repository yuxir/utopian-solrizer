require 'utopian_ruby_api'
require 'rsolr'
require 'date'
require 'time'

module UtopianSolrizer
  
  class << self
    # define utopian solr fileds by following solr dynamic fields conventions
    @@fields = {
      'id'         => 'id',
      'author'     => 'author_ssi',
      'moderator'  => 'moderator_ssim',
      'permlink'   => 'permlink_ssi',
      'category'   => 'category_ssi',
      'tags'       => 'tags_ssim',
      'title'      => 'title_tsim',
      'body'       => 'body_tsim',
      'created'    => 'created_dts',
      'repository' => 'repository_ssi'
    }

    
    # Add/update a post in solr
    def solrize_post(post, solr_options, overwrite=true)
      rsolr = RSolr.connect solr_options
      if (overwrite==true) or (not exist(solr_options, post.id))
        rsolr.add(
          @@fields['id']         => post.id,
          @@fields['author']     => post.author,
          @@fields['moderator']  => post.moderator,
          @@fields['permlink']   => post.permlink,
          @@fields['category']   => post.json_metadata['type'],
          @@fields['tags']       => post.json_metadata['tags'],
          @@fields['title']      => post.title,
          @@fields['body']       => post.body,
          @@fields['created']    => post.created,
          @@fields['repository'] => post.json_metadata['repository']['html_url']
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

    # Add posts within minutes to Solr
    def solrize_posts_within_minutes(criterias, solr_options, minutes)
      total_updated = 0
      limit = 100
      skip  = 0
      reached_end = false
      unless reached_end==true
        criterias = {"limit":limit,"skip":skip}
        UtopianRuby::UtopianRubyAPI.get_posts_obj(criterias).each do |post|
          if (Time.parse(Time.now.to_s)-Time.parse(post.created)) <= minutes*60
            #puts 'Solrizing post: ' + post.permlink
            total_updated = total_updated + 1
            solrize_post(post, solr_options)
          else
            reached_end=true
            break
          end
        end
        skip = skip + limit
      end
      total_updated
    end

    # search particular posts
    def query(solr_options, params)
      rsolr = RSolr.connect solr_options
      response = rsolr.select :params => params
    end

    # check if a solr document exists
    def exist(solr_options, id)
      params = { :q => 'id:'+id.to_s }
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
