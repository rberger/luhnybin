#!/usr/bin/env ruby

$debug = 0

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

def process_sample(line, num_string)
  if luhn_check(num_string)
    STDERR.puts "luhn true num_string: #{num_string}"   if $debug > 2

    slice.each do | k |
      line[k] = "X"
    end
    STDERR.puts "luhn true line: #{line.inspect}"   if $debug > 2
  end
end

def string_from_sample(sample, start, last)
  keys = sample.keys.sort
  keys.inject(String.new) { | str, k |  str += sample[k] }
end

def process_samples(line, samples)
  samples.each do | sample |
      STDERR.puts "Loop top sample: #{sample.inspect} length: #{sample.length}"   if $debug > 2
    if sample.length < 14
      STDERR.puts "< 14 sample: #{sample.inspect} length: #{sample.length}"   if $debug > 2
      next
    elsif sample.length == 14
      STDERR.puts "== 14 sample: #{sample.inspect} length: #{sample.length}"   if $debug > 2
      process_sample(line, string_from_sample(sample))
    elsif sample.length > 14
      
    end
  end
end

    [14,15,16].each do | num_length |
      keys = sample.keys.sort

      keys.each_slice(num_length).each do | slice |
        STDERR.puts "l: #{num_length} slice: #{slice.inspect}"   if $debug > 2

        break if slice.length != num_length

        num_string = slice.inject(String.new) { | str, k |  str += sample[k] }
        STDERR.puts "num_string: #{num_string.inspect}"   if $debug > 2

        if luhn_check(num_string)
          STDERR.puts "luhn true num_string: #{num_string}"   if $debug > 2

          slice.each do | k |
            line[k] = "X"
          end
          STDERR.puts "luhn true line: #{line.inspect}"   if $debug > 2
        end

      end
    end
  end
  line.join
end

def process_line(line)
  STDERR.puts "TOP line: #{line}"  if $debug > 2

  # Chunk up adjacent numbers (may include spaces and dashes)
  prev_is_cc_char = false
  samples = Array.new
  sindex = 0
  line.chars.each_with_index do | ch, index |
    case ch
    when /\d/
      unless  prev_is_cc_char
        samples[sindex] = Hash.new
        prev_is_cc_char = true
      end
      samples[sindex][index] = ch
    when /[^\d \-]/
      if  prev_is_cc_char
        prev_is_cc_char = false
        sindex += 1
      end
    end
  end

  output_line = process_samples(line.chars.to_a, samples)
  puts output_line
end

ARGF.each_with_index do |line, index|
#  STDERR.puts "--------------------- line #{index}"
  if index == 11
    $debug = 7
  else
    $debug = 0
  end
  
  process_line(line.chomp)
end

