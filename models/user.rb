class User
  include Neo4j::ActiveNode

  property :username, type: String, constraint: :unique

  has_many :out, :followers, type: :FOLLOWING,   model_class: :User
  has_many :in,  :followees, origin: :followers, model_class: :User
end