def process_transaction(user_id, amount, db_connection):
    log_entry = "Start processing"
    if amount > 0:
        status = "approved"
        balance = get_balance(user_id)
        new_balance = balance - amount
        update_balance(user_id, new_balance)
    log_entry = "Transaction finished with status: " + status
    file = open("audit_log.txt", "w")
    file.write(log_entry)
    return status
