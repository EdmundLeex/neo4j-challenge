Given a csv in the form of:

user_a_id, user_b_id

Write a ruby script that will connect to Neo4J and create a bidirectional relationship between two nodes with those ids.

If either node already exists it should be found for the new relationship.

The script should be able to handle problems and generate a list of exceptions while still completing.

The input will sometimes contain non numeric characters, these should be exceptions and not be inserted.

Performance and parallelism should be considered as the test data will be millions of rows.

## Preliminary
Follow these steps:

Install neo4j

`brew update`

`brew install neo4j`

Navigate to home directory and create database

`rake neo4j:install[community-latest]`

Seed the database

`ruby seed.rb`

## Start Console
Go to home directory and use `pry -r './config/environment'`

## Things to consider
-[ ] Duplicated relation
-[ ] Parallelism
-[ ] Non numeric characters
-[ ] uuid might not be unique if some records were deleted