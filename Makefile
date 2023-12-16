-include .env

build:; forge build

deploy-mumbai:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(MUMBAI_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv