#!/usr/bin/env ruby

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

def string_from_sample(sample, keys=nil)
  keys ||= sample.keys.sort
  keys.inject(String.new) { | str, k |  str += sample[k] }
end

def process_sample(line, num_string, keys)
  if luhn_check(num_string)
    keys.each do | k |
      line[k] = "X"
    end
  end
end

def window_sample(line, sample)
  idx = 0
  length = sample.length
  keys = sample.keys.sort
  while idx < length
    [14,15,16].each do | num_length |
      end_idx = idx + num_length - 1
      if end_idx < length
        window_keys = keys[idx..end_idx]
        num_string = string_from_sample(sample, window_keys)
        process_sample(line, num_string, window_keys)
      end
    end
    idx += 1
  end
end

def process_samples(line, samples)
  samples.each do | sample |
    if sample.length < 14
      next
    elsif sample.length >= 14
      window_sample(line, sample)
    end
  end
  line.join
end

def process_line(line)
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

    when /[^\d \-]/ # Not a digit, space or dash
      if  prev_is_cc_char
        prev_is_cc_char = false
        sindex += 1
      end
    end
  end

  puts process_samples(line.chars.to_a, samples)
end
ARGF.each_with_index do |line, index|
  process_line(line.chomp)
end
