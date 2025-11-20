require "mbrcode/version"
require "mutex_m"

module Mbrcode
  extend Mutex_m

  @sequence = 0

  class << self
    #
    # GENERATE MEMBERSHIP CODE
    #
    def generate(prefix: "mbr", shard: 1)
      shard_str = shard.to_i.to_s

      # STRICT: shard must be <= 3 characters always
      raise "Shard too long" if shard_str.length > 3

      prefix_str = normalize_prefix(prefix)

      seq = next_sequence

      max_digits = 16 - (prefix_str.length + shard_str.length)
      raise "Shard too long" if max_digits < 4

      digits  = format("%0#{max_digits}d", seq)
      grouped = digits.scan(/.{1,4}/).join("-")

      "#{prefix_str}#{shard_str}-#{grouped}"
    end

    private

    # -----------------------------------------------------------
    # PREFIX NORMALIZATION BASED ON YOUR SPECIFIC RULES
    # -----------------------------------------------------------
    def normalize_prefix(prefix)
      str = prefix.to_s.strip.upcase

      # 1) MULTI-WORD PREFIX → INITIALS (max 2 chars) → pad to 3
      if str.include?(" ")
        initials = str.split.map { |w| w[0] }.join
        return initials[0, 2].ljust(3, "0")
      end

      # 2) SINGLE-WORD RULES
      case str.length
      when 1, 2
        return str.ljust(3, "0")
      when 3
        return str
      when 4
        return str[0, 3]
      else
        mid = (str.length / 2) - 1
        return str[mid, 3]
      end
    end

    def next_sequence
      synchronize do
        cur = @sequence
        @sequence += 1
        cur
      end
    end
  end
end
