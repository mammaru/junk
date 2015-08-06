# coding: utf-8
require 'time'
require "active_support/core_ext/hash/conversions"
require 'fileutils'
require 'rexml/document'
#require 'json'
require 'mysql2'

# loading files
$LOAD_PATH << './lib'
require 'models.rb'
require 'io.rb'

# loading file and storing into hash
tw_xml = REXML::Document.new(File.new("./ignore/tweet.xml"))
tw_hash = Hash.from_xml(tw_xml.to_s)
@tweets = tw_hash["xml"]["list"]["tweet"].to_a

@tweets.map! do |tweet|
  
end

# convert
#{"time"=>"2015-08-04 14:57:28 +0900", "user"=>{"name"=>"310kei0414"}, "text"=>{"body"=>"@nappeket023 普通にd(￣ ￣)"}, "place"=>{"code"=>"25", "latitude"=>"36.30", "latitudeF"=>"36.3482935", "longitude"=>"138.55", "longitudeF"=>"138.5969629", "mark"=>"*0", "name"=>"軽井沢町"}}
# into
#{"time"=>2015-08-04 14:57:28 +0900, "user"=>{"name"=>"310kei0414"}, "text"=>{"body"=>"@nappeket023 普通にd(￣ ￣)"}, "place"=>{"code"=>"25", "latitude"=>36.30, "latitudeF"=>36.3482935, "longitude"=>138.55, "longitudeF"=>138.5969629, "mark"=>"*0", "name"=>"軽井沢町"}}
@tweets.each do |tweet|
  tweet["time"] = Time.parse(tweet.time)
  tweet["place"]["latitude"] = tweet["place"]["latitude"].to_f
  tweet["place"]["longitude"] = tweet["place"]["longitude"].to_f
  tweet["place"]["latitudeF"] = tweet["place"]["latitudeF"].to_f
  tweet["place"]["longitudeF"] = tweet["place"]["longitudeF"].to_f
  
end




# cnnection to database
config = YAML.load_file("./ignore/database.yml")
ActiveRecord::Base.establish_cnnection(config["db"]["development"])

