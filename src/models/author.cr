class Author
  include Clear::Model

  primary_key
  column name : String
  column email : String?

  has_many shards : Shard, through: "shard_authors"
end