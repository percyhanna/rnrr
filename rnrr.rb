require 'bitset'

module Rnrr
  DATA_SIZE = 60
  CHAR_SIZE = 5
  RNRR_BASE_32 = %w(B C D F G H J K L M N P Q R S T V W X Y Z 0 1 2 3 4 5 6 7 8 9 !).freeze
  BIG_ENDIAN = true

  def decode(str)
    str = str.gsub(/\s/, '')[0..11]
    bitset = Bitset.new(DATA_SIZE)

    str.chars.each_with_index do |char, index|
      bits = RNRR_BASE_32.index(char)

      CHAR_SIZE.times do |i|
        if BIG_ENDIAN
          bit = (bits & (2 ** (CHAR_SIZE - i - 1))) != 0
        else
          bit = (bits & (2 ** i)) != 0
        end

        bitset[index * 5 + i] = bit
      end
    end

    bitset
  end

  def bit_string(str)
    decode(str).map { |bit| bit ? 1 : 0 }
  end

  def debug(str)
    pretty_print(bit_string(str))
  end

  def pretty_print(bits)
    bits.each_slice(5).map { |bits| bits.join }.each_slice(2).map { |chunk| chunk.join(' ') }.each_slice(2).map { |chunk| chunk.join('  ') }.join('    ')
  end

  def compare(raw_lines)
    orig_lines = raw_lines.map { |str| bit_string(str) }
    lines = orig_lines.map(&:dup)

    columns = lines.first.zip(*lines[1..-1])
    columns.each_with_index do |col, index|
      if col.uniq.length == 1
        lines.each do |line|
          line[index] = '_'
        end
      end
    end

    orig_lines.each_with_index do |line, index|
      puts "  #{raw_lines[index]}\t\t#{pretty_print(line)}\t\t#{pretty_print(lines[index])}\t\t#{line.join}"
    end
  end
end

include Rnrr

chunk = []
loop do
  gets

  break if $_.nil?

  next if $_ =~ /\A#/

  if $_.chomp.empty?
    puts
    compare(chunk) unless chunk.empty?
    chunk = []
  else
    chunk << $_.chomp
  end
end

unless chunk.empty?
  puts
  compare(chunk)
end
