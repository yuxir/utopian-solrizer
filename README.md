Please follow me at: https://steemit.com/@yuxi


## What is the project about?


This project is aiming to index Utopian posts into solr, making it possible to do advanced searches. 
> Apache Solr is an open source enterprise search platform. Its major features include full-text search, hit highlighting, faceted search, real-time indexing, dynamic clustering, database integration, NoSQL features and rich document (e.g., Word, PDF) handling.


![](https://steemitimages.com/DQmV8Sk3rDUJTgZzUC8QjU8A93oPa5rfGade4dKKVMTFAsu/image.png)


## Technology Stack


Ruby V2.4
Gem V2.6.11
Apache Solr V5.0+
Utopian Ruby 0.0.3.1


## Roadmap


The current implementation performs CRUD to Solr server. As the focus of Solr is searching texts, Utopian Solrizer currently only index text fields, e.g. author, title, body, moderator etc and ignoring other fields, e.g. votes, pending payout. However, it's very easy to modify the code to index whatever you want. There are some features to be addressed in the future iterations.

* Index comments
* Move solr fields definition into a config file to give users more flexibility
* Add rake tasks to do batch job, e.g. add Utopian posts into Solr


## Test


A set of rspec test has been written here: 

https://github.com/yuxir/utopian-solrizer/blob/master/spec/utopian_solrizer_spec.rb

## How to contribute?


Just fork this project, create your feature branch, commit your changes and send a pull request!

https://github.com/yuxir/utopian-solrizer
    
## Installation

This gem has been registered in [rubygems.org](https://rubygems.org/gems/utopian_solrizer)  :

![](https://steemitimages.com/DQmYfhgBRRjL442gyKD5o5cLDvTHz6XXbiY6JE6BN5abDgu/image.png)

Assuming you already have Ruby development configured, then run:

```bash
gem install utopian_solrizer
```

## How to use it?


Assuming you have installed and configured Solr correctly. If not, please check [the offical Solr website](http://lucene.apache.org/solr/) for more information.

### Add Utopian post to solr

```ruby
solr_options = { read_timeout: 120, open_timeout: 120, url: 'http://localhost:8983/solr/utopian' }
post = UtopianRuby::UtopianRubyAPI.get_post_obj('yuxi','utopian-api-ruby-client')
UtopianSolrizer.solrize_post(post, solr_options)
```


### Query Solr to find all Utopian posts

```ruby
params = { :q => "*:*" }
response = UtopianSolrizer.query(solr_options, params)
```

### Check if an Utopian post indexed in Solr

```ruby
UtopianSolrizer.exist(solr_options, id)
```

### Index Utopian posts within a certain period to Solr

```ruby
UtopianSolrizer.solrize_posts_within_minutes({"limit":1,"status":"reviewed","type":"development"}, solr_options, 60*2)
```

### Example of indexed Utopian posts in Solr

![](https://steemitimages.com/DQmfF5vQGY2TknuWF2fm7h5ryoZigPN7PqCFdV17pG89KSu/image.png)
