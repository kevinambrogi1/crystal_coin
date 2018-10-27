require "openssl"

module CrystalCoin
  VERSION = "0.1.0"
  class Block
    # SAME AS 'ATTR_ACCESSOR'
    property current_hash : String
    
    def initialize(index = 0, data = "data", previous_hash = "hash")
      @index = index 
      @previous_hash = previous_hash 
      @timestamp = Time.now 
      @data = data 
      @current_hash = hash_block
    end
    
    def self.first(data = "Genesis Block")
      Block.new(
      data: data, 
      previous_hash: "0",
      )
    end  
    
    def self.next(previous_block, data = "Transaction Data")
      Block.new(
      index: previous_block.@index + 1,
      data: "Transaction data number (#{previous_block.@index + 1})",
      previous_hash: "#{previous_block.current_hash}"
      )
    end
    
    # Core first goes to private then to initialize
    private def hash_block
      hash = OpenSSL::Digest.new("SHA256")
      hash.update("#{@index}#{@timestamp}#{@data}#{@previous_hash}")
      hash.hexdigest
    end
  end
end

### Initial test:
# puts CrystalCoin::Block.new(data: "Same Data").current_hash

# # Print the genesis block:
# p CrystalCoin::Block.first

# ### Create a simple blockchain with 5 blocks + genesis (6)
blockchain = [ CrystalCoin::Block.first ]

previous_block = blockchain[0]

5.times do
  new_block  = CrystalCoin::Block.next( previous_block: previous_block )
  blockchain << new_block
  previous_block = new_block
end

p blockchain