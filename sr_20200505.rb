#http://hanzomemo.blogspot.com/2013/04/dbpediasparqlruby.html
#-*- coding: utf-8 -*-
require "sparql/client"

client = SPARQL::Client.new("http://localhost:3030/dataset.html?tab=upload&ds=/ifcp20200516")
results = client.query("
SELECT  ?s ?name
WHERE {
  ?s rdfs:label ?name;
     rdf:type crm:E1.
}
")
results.each do |solution|
	puts "#{solution[:s]} | #{solution[:name]}"
end