#!/usr/bin/env ruby

$debug = 7

def luhn_check(str)
  result = str.reverse.chars.each_with_index.inject(0) do |sum, (ch,  index) |
    digit = ch.to_i
    if index.even?
      sum += digit
    else
      doubled = digit * 2
      if doubled > 9
        sum += doubled.to_s.chars.inject(0) { |acc, ch| acc += ch.to_i }
      else
        sum += doubled
      end
    end
  end
  (result % 10 == 0) ? true : false
end

def process_sample(idx, sample)
  numbers = sample.gsub(/ -/, "")
  STDERR.puts "Top process_sample: idx: #{idx} sample: #{sample.inspect} numbers: #{numbers.inspect}" if $debug > 6

  if numbers.length < 14
    print sample
    idx += sample.length
    STDERR.puts "<14: idx: #{idx} sample: #{sample.inspect} numbers: #{numbers.inspect}"  if $debug > 6
    idx
  elsif (numbers.length == 14) &&  luhn_check(numbers)
    print sample.gsub(/\d/, "X")
    idx += sample.length
    STDERR.puts "=14 luhn true: numbers.length: #{numbers.length} idx: #{idx} sample: #{sample.inspect} numbers: #{numbers.inspect}"  if $debug > 6
    idx
  elsif (numbers.length == 15) &&  luhn_check(numbers)
    print sample.gsub(/\d/, "X")
    idx += sample.length
    STDERR.puts "=15 luhn true: numbers.length: #{numbers.length} idx: #{idx} sample: #{sample.inspect} numbers: #{numbers.inspect}"  if $debug > 6
    idx
  elsif (numbers.length == 16) &&  luhn_check(numbers)
    print sample.gsub(/\d/, "X")
    idx += sample.length
    STDERR.puts "=6 luhn true: numbers.length: #{numbers.length} idx: #{idx} sample: #{sample.inspect} numbers: #{numbers.inspect}"  if $debug > 6
    idx
  else
    m = /^([ -]*\d)/.match(sample)
    print m[1]
    idx += 1
    idx = process_sample(idx, sample[m[1].length..-1])
    STDERR.puts ">16 luhn false: numbers.length: #{numbers.length} idx: #{idx} sample: #{sample.inspect} numbers: #{numbers.inspect} m[1]: #{m[1].inspect}"  if $debug > 6
    idx
  # else
  #   print sample
  #   idx += sample.length
  #   STDERR.puts "process_sample ELSE numbers.length: #{numbers.length} idx: #{idx} sample: #{sample.inspect} numbers: #{numbers.inspect}"  if $debug > 6
  #   idx
  end
end

def process_line(line)
  STDERR.puts "TOP line: #{line}"  if $debug > 2
  idx = 0
  while idx < line.length
    STDERR.puts "Top while idx: #{idx.inspect} line.length: #{line.length}"  if $debug > 6
    if line[idx] !~ /\d| |-/
      m = /([^\d \-]+)/.match(line[idx..-1])
      STDERR.puts "Not Numbers m[1]: #{m[1]} m: #{m.inspect}"  if $debug > 6
      print m[1]
      idx += m[1].length
      STDERR.puts "NOT number,space,dash idx: #{idx.inspect} m[1].length: #{m[1].length} m[1]: #{m[1].inspect}"  if $debug > 6
    else
      STDERR.puts "Initial Sample: line[#{idx.inspect}]: #{line[idx..-1].inspect}"  if $debug > 6
      m = /([\d \-]+)/.match(line[idx..-1])
      STDERR.puts "Initial m[1]: #{m[1]} m: #{m.inspect}"  if $debug > 6
      idx = process_sample(idx, m[1])
      STDERR.puts "After process_sample idx: #{idx.inspect}"  if $debug > 6
      idx
    end
  end
end

ARGF.each do |line|
  process_line(line)
end

