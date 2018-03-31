require "./crankypants/repo"
require "./crankypants/*"

module Crankypants
end

# -- +micrate Up
# -- SQL in section 'Up' is executed when this migration is applied
# create table posts (id int primary key, key text, title text, body text);
# insert into posts values (1, "hello-world", "Hello world", "I am the first post. Isn't it amazing?");
#
# -- +micrate Down
# -- SQL section 'Down' is executed when this migration is rolled back
# drop table posts;


# Run web app
Crankypants::Web.run
