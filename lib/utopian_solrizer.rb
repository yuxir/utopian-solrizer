require 'utopian_ruby_api'
require 'rsolr'
require 'date'
require 'time'

module UtopianSolrizer
  
  class << self
    # define utopian solr fileds by following solr dynamic fields conventions
    @@utopian_solr_field_mapping = {
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

    # set default utopian fields to index
    @@default_fields = ['author',
                        'moderator',
                        'permlink',
                        'category',
                        'tags',
                        'title',
                        'body',
                        'created',
                        'repository'
                        ]
    
    # Add/update a post in solr
    def solrize_post(post, solr_options, solr_fields=nil)
      rsolr = RSolr.connect solr_options
      if solr_fields.nil? or solr_fields.length==0
        solr_fields = @@default_fields
      end
      solr_json = {}

      solr_fields.each do |f|
        solr_json[@@utopian_solr_field_mapping[f]] = post_value(post, f)  
      end
      rsolr.add solr_json
      rsolr.commit
    end

    # return post value for a particular field_name
    def post_value(post, field_name)
      post.id                                      if field_name=='id'
      post.author                                  if field_name=='author'
      post.moderator                               if field_name=='moderator'
      post.permlink                                if field_name=='permlink'
      post.json_metadata['type']                   if field_name=='category'
      post.json_metadata['tags']                   if field_name=='tags'
      post.title                                   if field_name=='title'
      post.body                                    if field_name=='body'
      post.created                                 if field_name=='created'
      post.json_metadata['repository']['html_url'] if field_name=='repository'
      post.flagged                                 if field_name=='flagged'
      post.reviewed                                if field_name=='reviewed'
      post.pending                                 if field_name=='pending'
      post.last_update                             if field_name=='last_update'
      post.active                                  if field_name=='active'
    end

    # Add/update a post in solr
 #   def solrize_post(post, solr_options, overwrite=true)
 #     rsolr = RSolr.connect solr_options
 #     if (overwrite==true) or (not exist(solr_options, post.id))
 #       rsolr.add(
 #         @@fields['id']         => post.id,
 #         @@fields['author']     => post.author,
 #         @@fields['moderator']  => post.moderator,
 #         @@fields['permlink']   => post.permlink,
 #         @@fields['category']   => post.json_metadata['type'],
 #         @@fields['tags']       => post.json_metadata['tags'],
 #         @@fields['title']      => post.title,
 #         @@fields['body']       => post.body,
 #         @@fields['created']    => post.created,
 #         @@fields['repository'] => post.json_metadata['repository']['html_url']
 #       )
 #       rsolr.commit
 #     end
 #   end

 #   def post_json(post)
 #     {
 #         @@fields['id']         => post.id,
 #         @@fields['author']     => post.author,
 #         @@fields['moderator']  => post.moderator,
 #         @@fields['permlink']   => post.permlink,
 #         @@fields['category']   => post.json_metadata['type'],
 #         @@fields['tags']       => post.json_metadata['tags'],
 #         @@fields['title']      => post.title,
 #         @@fields['body']       => post.body,
 #         @@fields['created']    => post.created,
 #         @@fields['repository'] => post.json_metadata['repository']['html_url']
 #     }
 #   end

    # solrize from json
    def solrize_from_json(json_documents, solr_options)
      rsolr = RSolr.connect solr_options
      rsolr.add json_documents
    end

    # Batch adding Solr document
    def batch_solrize_posts_by_criterias(criterias, solr_options)
      total_updated = 0
      UtopianRuby::UtopianRubyAPI.get_posts_obj(criterias).each do |post|
        total_updated = total_updated + 1
      end

      #solrize_post(post, solr_options)
      batch_solrize_post documents
      total_updated
    end


    # Add posts by criterias
    def solrize_posts_by_criterias(criterias, solr_options)
      total_updated = 0
      UtopianRuby::UtopianRubyAPI.get_posts_obj(criterias).each do |post|
        solrize_post(post, solr_options)
        total_updated = total_updated + 1
      end
      total_updated
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
