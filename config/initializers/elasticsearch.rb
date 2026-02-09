
Searchkick.client = Elasticsearch::Client.new(
  url: ENV.fetch("ELASTICSEARCH_LOCAL_URL")
)
