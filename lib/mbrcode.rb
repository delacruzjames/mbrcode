require "mbrcode/version"
require "mutex_m"

module Mbrcode
  extend Mutex_m

  @sequence = 0

  class << self
    #
    # New Rules:
    # - Prefix processed to exactly 4 chars using logic described
    # - MAX 16 digits total after prefix+shard
    #
    def generate(prefix: "mbr", shard: 1)
      prefix_str = normalize_prefix(prefix)
      shard_str  = shard.to_i.to_s

      seq = next_sequence

      # remaining characters allowed for digits
      max_digits = 16 - (prefix_str.length + shard_str.length)

      # enforce enough space for meaningful numbering
      raise "Shard too long" if max_digits < 4

      digits = format("%0#{max_digits}d", seq)

      grouped =
        if max_digits > 4
          digits.scan(/.{1,4}/).join("-")
        else
          digits
        end

      "#{prefix_str}#{shard_str}-#{grouped}"
    end

    private

    # -----------------------------
    # PREFIX NORMALIZATION LOGIC
    # -----------------------------
    def normalize_prefix(prefix)
      str = prefix.to_s.strip.upcase

      # Multi-word? Use initials.
      if str.include?(" ")
        initials = str.split.map { |w| w[0] }.join
        return pad_or_trim(initials)
      end

      # Single word:
      if str.length < 4
        return pad_or_trim(str)
      else
        # Use first 4 chars
        return str[0, 4]
      end
    end

    def pad_or_trim(str)
      if str.length >= 4
        str[0, 4]
      else
        # pad numbers until length = 4
        str.ljust(4, "0")
      end
    end

    def next_sequence
      synchronize do
        current = @sequence
        @sequence += 1
        current
      end
    end
  end
end
