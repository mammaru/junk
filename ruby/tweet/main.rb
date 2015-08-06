# coding: utf-8

# addition
$LOAD_PATH << '/lib'
require 'models.rb'
require 'io.rb'

require "active_support/core_ext/hash/conversions"
require 'fileutils'
require 'rexml/document'
require 'json'

# Loading sample data from xml file
tw_xml = REXML::Document.new(File.new("./ignore/tweet.xml"))

tw_hash = Hash.from_xml(tw_xml)
