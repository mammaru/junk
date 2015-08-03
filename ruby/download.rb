#!/usr/bin/env ruby

start = Time.local(2013, 12, 1)
base_url = "http://k-db.com/site/download.aspx?p=all&download=csv&date="
0.upto(65) do |i|
  d = start + i * 24 * 60 * 60
  str = d.strftime("%Y-%m-%d")
  `curl "#{base_url + str}" | nkf > #{str}`
  sleep 5
end
