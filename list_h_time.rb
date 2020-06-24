require 'net/http'
require 'uri'
require 'active_support'
require 'active_support/core_ext'
require 'json'

#　sparqlクエリを投げるuriをセット
uri = URI.parse('http://localhost:3030/ifcp20200530/query')

# sparqlクエリ。ここを差し替えれば取ってくるデータの中身が変わる
sql = "     
PREFIX crm: <http://purl.org/NET/cidoc-crm/core#> 
PREFIX ifcp: <http://example.org/ifcp/> 
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
SELECT  ?s ?name ?hs_time ?he_time
WHERE {
 ?s rdfs:label ?name.
 ?event crm:P17 ?s;
  crm:P4 [
    crm:P116 ?hs_time;
    crm:P115 ?he_time
  ].
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
  puts "URI: " + row["s"]["value"] + " | 名前: " + row["name"]["value"] + " | 開始日: " + row["hs_time"]["value"] +" | 終了日: " + row["he_time"]["value"]
end