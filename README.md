# CabalDirectory - A Decentralized Community Index

CabalDirectory is a decentralized community index built on the blockchain, enabling individuals to register, manage, and update their digital profiles securely and transparently. This protocol ensures full control and ownership of user data, providing a permissioned structure for access and modification of profiles.

## Features

- **Decentralized Member Registration**: Community members can register with their name, bio, and categories they belong to.
- **Secure Data Management**: Only the steward (creator) of a record can modify or remove it.
- **Permission Management**: Stewards can control who can view their data through a simple access control mechanism.
- **Efficient Data Validation**: Ensures proper input format and categories with built-in validation.
- **Scalable**: The directory grows as more members register, and operations are designed to be lightweight for scalability.

## Getting Started

To use or contribute to CabalDirectory, follow the steps below.

### Prerequisites

1. **Clarity**: The smart contract is written in the Clarity programming language, designed to run on the Stacks blockchain.
2. **Stacks Wallet**: Make sure to have a Stacks wallet to interact with the blockchain.

### Deploying

To deploy the contract to the Stacks blockchain:

1. **Install Stacks CLI** (if you haven't already):
   ```bash
   curl -sSL https://stacks.co/downloads/stacks-wallet-cli-linux-x64.tar.gz | tar -xz
   ```

2. **Deploy the Contract**:
   After setting up the Stacks CLI, follow the steps in the Stacks documentation to deploy your contract to the network.

### Contract Functions

- **`register-new-member`**: Register a new member with their name, bio, and categories.
- **`update-member-bio`**: Update the biography of an existing member.
- **`update-member-categories`**: Update the categories associated with a member.
- **`remove-member`**: Remove a member from the directory.

For detailed documentation of each function, please refer to the smart contract code in `contract.clarity`.

### Testing

1. **Unit Tests**: Run the test suite using the Clarity testing framework.
2. **Manual Testing**: Interact with the contract directly via the Stacks wallet or test on the Stacks testnet.

### Contributing

We welcome contributions! Please fork the repo, create a branch, and submit a pull request for any bug fixes or new features.

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) .