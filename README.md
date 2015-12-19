Given a csv in the form of:

user_a_id, user_b_id

Write a ruby script that will connect to Neo4J and create a bidirectional relationship between two nodes with those ids.

If either node already exists it should be found for the new relationship.

The script should be able to handle problems and generate a list of exceptions while still completing.

The input will sometimes contain non numeric characters, these should be exceptions and not be inserted.

Performance and parallelism should be considered as the test data will be millions of rows.