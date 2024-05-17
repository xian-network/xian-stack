balances = Hash(default_value=0)
metadata = Hash()


@construct
def seed():
    balances[ctx.caller] = 1_000_000

    metadata['token_name'] = "TEST TOKEN"
    metadata['token_symbol'] = "TST"
    metadata['token_logo_url'] = 'https://some.token.url/test-token.png'
    metadata['token_website'] = 'https://some.token.url'
    metadata['operator'] = ctx.caller


@export
def change_metadata(key: str, value: Any):
    assert ctx.caller == metadata['operator'], 'Only operator can set metadata!'
    metadata[key] = value


@export
def transfer(amount: float, to: str):
    assert amount > 0, 'Cannot send negative balances!'
    assert balances[ctx.caller] >= amount, 'Not enough coins to send!'

    balances[ctx.caller] -= amount
    balances[to] += amount

    return f"Sent {amount} to {to}"


@export
def approve(amount: float, to: str):
    assert amount > 0, 'Cannot send negative balances!'
    balances[ctx.caller, to] += amount

    return f"Approved {amount} for {to}"


@export
def transfer_from(amount: float, to: str, main_account: str):
    assert amount > 0, 'Cannot send negative balances!'
    assert balances[main_account, ctx.caller] >= amount, f'Not enough coins approved to send! You have {balances[main_account, ctx.caller]} and are trying to spend {amount}'
    assert balances[main_account] >= amount, 'Not enough coins to send!'

    balances[main_account, ctx.caller] -= amount
    balances[main_account] -= amount
    balances[to] += amount

    return f"Sent {amount} to {to} from {main_account}"
