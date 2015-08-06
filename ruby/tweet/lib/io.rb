# coding: utf-8
$LOAD_PATH << '/lib'
require 'rubygems'
require 'active_record'
require 'fileutils'
require 'rexml/document'
require 'json'

# Loading sample data from xml file
tw_xml = REXML::Document.new(File.new("./ignore/tweet.xml"))



config = YAML.load_file("./ignore/database.yml")

ActiveRecord::Base.establish_cnnection(config["db"]["development"])

# Definition of object mapped to database 
class Tweet < ActiveRecord::Base
  self.table_name = "tweets"
end

class User < ActiveRecord::Base

end
