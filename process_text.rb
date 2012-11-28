#!/usr/bin/env ruby

def luhn_check(str)
  result = str.reverse.chars.each_with_index.inject(0) do |sum, (ch,  index) |
#    STDERR.puts "TOP sum: #{sum.inspect} d: #{ch.inspect} i: #{index.inspect}"
    digit = ch.to_i
    if index.even?
#      STDERR.puts "EVEN Before digit: #{digit} sum: #{sum}"
      sum += digit
#      STDERR.puts "EVEN After digit: #{digit} sum: #{sum}"
      sum
    else
      doubled = digit * 2
      if doubled > 9
#        STDERR.puts "ODD Doubled > 9  Before  digit: #{digit} doubled: #{doubled} sum: #{sum}"
        sum += doubled.to_s.chars.inject(0) { |acc, ch| acc += ch.to_i }
#        STDERR.puts "ODD Doubled > 9  After  digit: #{digit} doubled: #{doubled} sum: #{sum}"
        sum
      else
#        STDERR.puts "ODD Doubled < 9  Before digit: #{digit} doubled: #{doubled} sum: #{sum}"
        sum += doubled
#        STDERR.puts "ODD Doubled < 9  After digit: #{digit} doubled: #{doubled} sum: #{sum}"
        sum
      end
    end
  end
  (result % 10 == 0) ? true : false
end

def process_line(line)
  STDERR.puts "line: #{line.inspect}"
  m = /(\d{14,16})/.match(line)
  unless m
    STDERR.puts "No Digits or not right number of digits #{line.inspect}"
    puts  line
  else
    if luhn_check m[1]
      STDERR.puts "lun_check #{m[1].inspect} true #{line.inspect}"
      str = "X" * (m[1].length)
      puts str
    else
      STDERR.puts "lun_check #{m[1].inspect} false line: #{line.inspect}"
      puts line
    end
  end
end

ARGF.each do |line|
  process_line(line)
end

