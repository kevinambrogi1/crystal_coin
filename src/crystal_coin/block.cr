require "./proof_of_work"
require "./transaction"

module CrystalCoin
    class Block
        include ProofOfWork
        
        JSON.mapping(
        index: Int32,
        current_hash: String,
        nonce: Int32,
        previous_hash: String,
        transactions: Array(Transaction),
        timestamp: Time
        )
        
        def initialize(index = 0, transactions = [] of Transaction, previous_hash = "hash")
            @index = index 
            @transactions = transactions
            @previous_hash = previous_hash 
            @timestamp = Time.now
            @nonce = proof_of_work
            @current_hash = calc_hash_with_nonce(@nonce)
        end
        
        def self.first(data = "Genesis Block")
            Block.new(
            previous_hash: "0"
            )
        end  
        
        def self.next(previous_block, transactions = [] of Transaction)
            Block.new(
            transactions: transactions,
            index: previous_block.@index + 1,
            previous_hash: "#{previous_block.current_hash}"
            )
        end
        
        def recalculate_hash
            @nonce = proof_of_work
            @current_hash = calc_hash_with_nonce(@nonce)
        end
    end
end

### Initial test:
# puts CrystalCoin::Block.new(data: "Same Data").current_hash

# # Print the genesis block:
# p CrystalCoin::Block.first

# ### Create a simple blockchain with 5 blocks + genesis (6)
blockchain = [ CrystalCoin::Block.first ]
# puts blockchain.inspect
previous_block = blockchain[0]

5.times do
    new_block  = CrystalCoin::Block.next( previous_block: previous_block )
    blockchain << new_block
    previous_block = new_block
    # puts new_block.inspect
end

p blockchain