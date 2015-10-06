#!/usr/local ruby
#!/usr/bin ruby
require 'csv'
require 'pg'

$table = "product_test"
$hostname = "localhost"
$table_columns = ["description", "lookupcode", "price", "itemtype", "cost", "quantity", "reorderpoint", "restocklevel", "parentitem", "extendeddescription", "active", "msrp", "createdon"]
$table_columns_string = $table_columns.join(",")
connection_parameters = {
  :host => "localhost",
  :port => "5432",
  :user => "gazelle",
  :password => "gazelle123",
  :dbname => "gazelledb"
}
connection = PG::Connection.new(connection_parameters)
puts connection.server_version
connection.prepare('product_import', "insert into #{$table} (#{$table_columns_string}) values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13)")

CSV.foreach("#{Dir.home}/Documents/software_engineering/products.csv", quote_char: "|", :headers => true) do |product|
  $datecreated = product['DateCreated']
  if $datecreated == nil then 
    $datecreated = "1980-01-01 00:00:00.000"
  end
  
connection.exec_prepared('product_import', [product['Description'], product['ItemLookupCode'], product['Price'], product['ItemType'], product['Cost'], product['Quantity'], product['ReorderPoint'], product['RestockLevel'], product['ParentItem'], product['ExtendedDescription'], product['Inactive'], product['MSRP'], $datecreated])
end