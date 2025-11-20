require "mbrcode"

RSpec.describe Mbrcode do
  before { Mbrcode.instance_variable_set(:@sequence, 0) } # reset sequence for predictable tests

  describe ".generate" do
    context "default behavior" do
      it "generates a code with the default prefix MBR (normalized to MBR)" do
        code = Mbrcode.generate
        expect(code).to start_with("MBR1-")
      end

      it "increments the sequence number" do
        first  = Mbrcode.generate
        second = Mbrcode.generate
        expect(first).not_to eq(second)
      end
    end

    context "prefix rules (new specification)" do
      it "pads prefix shorter than 3 chars with zeros (KP → KP0)" do
        code = Mbrcode.generate(prefix: "kp")
        expect(code).to start_with("KP01-")
      end

      it "keeps 3-character prefixes as is (KKP stays KKP)" do
        code = Mbrcode.generate(prefix: "kkp")
        expect(code).to start_with("KKP1-")
      end

      it "trims 4-character prefixes to first 3 (WKKP → WKK)" do
        code = Mbrcode.generate(prefix: "WKKP")
        expect(code).to start_with("WKK1-")
      end

      it "extracts middle 3 letters for 5+ char prefixes (WKKPP → KKP)" do
        code = Mbrcode.generate(prefix: "WKKPP")
        expect(code).to start_with("KKP1-")
      end

      it "multi-word prefixes convert to initials and pad to 3 chars" do
        # "karate membership" → KM → pad → KM0
        code = Mbrcode.generate(prefix: "karate membership")
        expect(code).to start_with("KM01-")
      end
    end

    context "shard logic" do
      it "appends shard number after normalized prefix" do
        # 'user' → 'USE' (first 3 of USER)
        code = Mbrcode.generate(prefix: "user", shard: 9)
        expect(code).to start_with("USE9-")
      end

      it "raises an error when shard is too large for 16-char rule" do
        expect {
          Mbrcode.generate(prefix: "abcd", shard: 123456789)
        }.to raise_error(/Shard too long/)
      end
    end

    context "length compliance" do
      it "ensures total raw length (no dashes) does not exceed 16 chars" do
        code = Mbrcode.generate(prefix: "mem", shard: 1)
        raw = code.delete("-")
        expect(raw.length).to be <= 16
      end
    end
  end
end
