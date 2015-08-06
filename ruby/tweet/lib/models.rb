require 'rubygems'
require 'active_record'

# Definition of object mapped to database 
class Tweet < ActiveRecord::Base
  self.table_name = "tweets"
end

class User < ActiveRecord::Base

end
