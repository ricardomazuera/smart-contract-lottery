# Loading environment variables 
ifeq (,$(wildcard .env))
  $(error "The file .env doesn't exists")
else
  include .env
  export
endif

# variables
RPC_URL=http://localhost:8545
CAST_WALLET_PK_NAME=localPK
SENDER_ADDRESS=0x90f79bf6eb2c4f870365e785982e1f101e93b906
CONTRACT_ADDRESS=0x057ef64E23666F000b34aE31332854aCBd1c8544
SEPOLIA_WALLET_PK_NAME=sepoliaKey
SEPOLIA_SENDER_ADDRESS=0x589605619b607c9ebf8520ce75d3007f4dafd3d9

run-unittests:
	@echo "Formatting code..."
	forge fmt
	@echo "Running tests"
	forge coverage
	@echo "Exporting coverage report"
	forge coverage --report debug > coverage.txt

run-forkedtests:
	@echo "Running tests forked"
	forge test --fork-url $(SEPOLIA_RPC_URL)