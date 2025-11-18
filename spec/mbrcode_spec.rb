require "mbrcode"

RSpec.describe Mbrcode do
  describe ".generate" do
    context "default behavior" do
      it "generates a code with the default prefix MBR" do
        code = Mbrcode.generate
        expect(code).to match(/^MBR0?1-\d{1,4}(-\d{1,4})*/)
      end

      it "increments the sequence number" do
        first  = Mbrcode.generate
        second = Mbrcode.generate
        expect(first).not_to eq(second)
      end
    end

    context "prefix rules" do
      it "pads prefix shorter than 4 chars with zeros" do
        code = Mbrcode.generate(prefix: "ab")
        expect(code).to start_with("AB00")
      end

      it "extracts initials when multiple words are used" do
        code = Mbrcode.generate(prefix: "karate membership")
        # KM00-xxxx
        expect(code).to match(/^KM00\d?-\d/)
      end

      it "trims long single-word prefixes to the first 4 chars" do
        code = Mbrcode.generate(prefix: "customer")
        expect(code).to start_with("CUST")
      end

      it "keeps exact 4-character prefixes as is" do
        code = Mbrcode.generate(prefix: "USER")
        expect(code).to start_with("USER")
      end
    end

    context "shard logic" do
      it "appends shard number right after normalized prefix" do
        code = Mbrcode.generate(prefix: "user", shard: 9)
        expect(code).to match(/^USER9-/)
      end

      it "raises an error when shard consumes space beyond the 16-character limit" do
        expect {
          Mbrcode.generate(prefix: "abcd", shard: 123456789)
        }.to raise_error(/Shard too long/)
      end
    end

    context "length compliance" do
      it "ensures the generated code does not exceed 16 characters before grouping" do
        code = Mbrcode.generate(prefix: "mem", shard: 1)
        raw = code.gsub("-", "") # remove dashes for length check
        expect(raw.length).to be <= 16
      end
    end
  end
end
