#!/usr/bin/env ruby
# coding: utf-8

event = ARGV[0]
if event == 'songstart'
  d = Hash.new
  STDIN.each_line { |line| d.store(*line.chomp.split('=', 2)) }

  File.open("#{ENV['HOME']}/.config/pianobar/current-song.txt", 'w') do |f|
    f.write("#[fg=colour0]#{d['title']} - #{d['artist']} [#{d['stationName']}]#[fg=default,bg=default] ")
  end
end
