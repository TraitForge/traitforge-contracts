# Phony targets (for organization)
.PHONY: build clean test deploy

# Compilation of contracts
build:
	@echo "Compiling contracts..."
	forge build

# Clean compiled artifacts
clean:
	@echo "Cleaning up..."
	forge clean

deploy-accessController:
	@echo "Deploying AccessControler contract on $(NETWORK)..."
	forge script script/deployment/00_DeployAccessController.s.sol --rpc-url $(NETWORK) --broadcast --verify --optimize

deploy-addressProvider:
	@echo "Deploying AddressProvider contract on $(NETWORK)..."
	forge script script/deployment/01_DeployAddressProvider.s.sol --rpc-url $(NETWORK) --broadcast --verify --optimize

deploy-all:
	@echo "Deploying all contracts on $(NETWORK)..."
	forge script script/deployment/DeployAll.s.sol --rpc-url $(NETWORK) --with-gas-price 600 --broadcast --verify --optimize

update-addressProvider:
	@echo "Updating AddressProvider contract on $(NETWORK)..."
	forge script script/deployment/11_UpdateAddressProvider.s.sol --rpc-url $(NETWORK) --with-gas-price 600 --broadcast --verify --optimize

update-roles:
	@echo "Updating roles on $(NETWORK)..."
	forge script script/deployment/12_UpdateRoles.s.sol --rpc-url $(NETWORK) --with-gas-price 600 --broadcast --verify --optimize

deploy-airdrop:
	@echo "Deploying airdrop contract on $(NETWORK)..."
	forge script script/deployment/02_DeployAirdrop.s.sol --rpc-url $(NETWORK) --with-gas-price 600 --broadcast --verify --optimize

deploy-devFund:
	@echo "Deploying devFund contract on $(NETWORK)..."
	forge script script/deployment/03_DeployDevFund.s.sol --rpc-url $(NETWORK) --broadcast --verify --optimize

deploy-daoFund:
	@echo "Deploying daoFund contract on $(NETWORK)..."
	forge script script/deployment/04_DeployDaoFund.s.sol --rpc-url $(NETWORK) --broadcast --verify --optimize

deploy-nukeFund:
	@echo "Deploying nukeFund contract on $(NETWORK)..."
	forge script script/deployment/05_DeployNukeFund.s.sol --rpc-url $(NETWORK) --broadcast --verify --optimize

deploy-entityForging:
	@echo "Deploying entityForging contract on $(NETWORK)..."
	forge script script/deployment/06_DeployEntityForging.s.sol --rpc-url $(NETWORK) --broadcast --verify --optimize

deploy-entityTrading:
	@echo "Deploying entityTrading contract on $(NETWORK)..."
	forge script script/deployment/07_DeployEntityTrading.s.sol --rpc-url $(NETWORK) --broadcast --verify --optimize

deploy-entropyGenerator:
	@echo "Deploying entropyGenerator contract on $(NETWORK)..."
	forge script script/deployment/08_DeployEntropyGenerator.s.sol --rpc-url $(NETWORK) --broadcast --verify --optimize

deploy-trait:
	@echo "Deploying trait contract on $(NETWORK)..."
	forge script script/deployment/09_DeployTrait.s.sol --rpc-url $(NETWORK) --broadcast --verify --optimize

deploy-traitForgeNft:
	@echo "Deploying traitForgeNft contract on $(NETWORK)..."
	forge script script/deployment/10_DeployTraitForgeNft.s.sol --rpc-url $(NETWORK) --broadcast --verify --optimize