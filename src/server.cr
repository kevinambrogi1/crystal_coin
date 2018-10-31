# require "amber"
require "kemal"
require "uuid"
require "json"

require "./crystal_coin"

# Create our Blockchain
blockchain = CrystalCoin::Blockchain.new

# Generate a globally unique address for this node
node_identifier = UUID.random.to_s

# Send the blockchain as json objects
get "/chain" do
    { chain: blockchain.chain }.to_s.to_json
end

get "/mine" do
    blockchain.mine
    "Block with index=#{blockchain.chain.last.index} is mined."
end

get "/pending" do
    { transactions: blockchain.uncommitted_transactions }.to_s.to_json
end

get "/nodes/resolve" do
    if blockchain.resolve
        "Succesfully updated the chain"
    else
        "Current chain is up_to_date"
    end 
end

post "/transactions/new" do |env|
    transaction = CrystalCoin::Block::Transaction.new(
    from: env.params.json["from"].as(String),
    to: env.params.json["to"].as(String),
    amount: env.params.json["amount"].as(Int64)
    )
    
    blockchain.add_transaction(transaction)
    
    "Transaction #{transaction} has been added to the node"
end

post "/nodes/register" do |env|
    nodes = env.params.json["nodes"].as(Array)
    
    raise "Empty array" if nodes.empty?
    
    nodes.each do |node|
        blockchain.register_node(node.to_s)
    end
    
    "New nodes have been added: #{blockchain.nodes}"
end


# Amber.run
Kemal.run