<h1 align=center><code>Security Toolkit</code></h1>

A collection of smart contracts for implementing security controls and guardrails. Useful for OpSec and educational purposes.

**NB: It IS NOT AUDITED/REVIEWED. Do Your Own Research and Use At Your Own Risk**

## Levels

## Security 1

Simple two role model, `operator` and `governance`. Operator can be updated by governance. Governance can be updated by itself but requires acceptance from the new one.

Operator can pause all the smart contract operation via [SCRAM()](https://en.wikipedia.org/wiki/Scram). Only governance can unpause.

When paused, `governance` can withdraw any asset via the respective methods: `emergencyWithdrawERC20ETH`, `emergencyWithdrawERC721`, `emergencyBatchWithdrawERC721`, `emergencyWithdrawERC1155`, `emergencyBatchWithdrawERC1155`.

You can annotate methods via these modifiers:
- `whenPaused` and `whenNotPaused`
- `onlyGovernance`
- `onlyOperatorOrGovernance`

## Security 2

Extends Security 1 model. 

Adds possibility for governance to execute any tx on behalf of the contract via `emergencyExecute` when paused.

## Security 3

Extends Security 2 model.

When paused, all the methods annotated with `whenPausedthenProxy` fallback to an external `emergencyImplementation`. Useful to override specific methods with an upgradable failsafe contract.

## Security 4

Extends Scurity 4 model.

Add an allowlist, any method annotated with `onlyAllowlisted` can be execute only by allowed users when allowlisting is in place.

Only governance can enable/disable the feature.

Operators or governance can enable a user with `allow`, only governance can disable via `disallow`.

## Contribute

Feel free to open issues, fork and share your practices!
