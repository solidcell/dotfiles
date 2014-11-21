#!/usr/bin/env ruby
# coding: utf-8

event = ARGV[0]
if event == 'songstart'
  d = Hash.new
  STDIN.each_line { |line| d.store(*line.chomp.split('=', 2)) }

  File.open("#{ENV['HOME']}/.config/pianobar/current-song.txt", 'w') do |f|
    station_name = d['stationName'].chomp(' Radio')
    reset = '#[fg=default,bg=default]'
    f.write("#[fg=colour0]#{d['title']} #[fg=colour22]by#{reset} #{d['artist']} #[fg=colour22][#{station_name}]#{reset} ")
  end
end
