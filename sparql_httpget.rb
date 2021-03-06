#https://yoshitia.hatenablog.com/entry/2018/07/22/010146
require 'net/http'
require 'uri'
require 'active_support'
require 'active_support/core_ext'
require 'json'

uri = URI.parse('http://localhost:3030/ifcp20200516/query')

sql = "
       PREFIX crm: <http://purl.org/NET/cidoc-crm/core#> 
PREFIX ifcp: <http://example.org/ifcp/> 
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
SELECT DISTINCT ?s ?name
WHERE {
  ?s rdfs:label ?name;
     rdf:type crm:E1.
  FILTER(LANG(?name)='ja')
}
      "

# ruby imassparql_httpget.rb json で　生のjsonデータ出力
if ARGV[0] == "json" then
  puts result
  exit
end

# ruby imassparql_httpget.rb first で最初の一行目のデータだけ出力。
# 狙ったデータが取得できてるかどうかの確認用。
if ARGV[0] == "first" then
  data = result["results"]["bindings"]
  puts data.first
  exit
end

# sparqlクエリをuriencodeしてセットする
uri.query = {
  query: sql
}.to_param

# httpリクエスト送信
json = Net::HTTP.get(uri)
# 帰ってきたjsonデータをrubyのハッシュにする
result = JSON.parse(json)
# 以下データを出力
data = result["results"]["bindings"]
data.each do |row|
  puts "名前: " + row["s"]["value"] + " | 胸囲: " + row["name"]["value"]
end