def get_balance(user_id):
    # Заглушка для корректной работы функции
    return 100.0


def update_balance(user_id, balance):
    # Заглушка для корректной работы функции
    pass


def process_transaction(user_id, amount, db_connection):
    # Безопасная инициализация статуса по умолчанию
    status = "pending"
    
    # Исправление мертвого присваивания: логируем реальный старт операции
    log_entry = f"Start processing for user {user_id} with connection {db_connection}\n"
    
    if amount > 0:
        status = "approved"
        balance = get_balance(user_id)
        new_balance = balance - amount
        update_balance(user_id, new_balance)
        
    # Дозаписываем финальный статус в лог-строку
    log_entry += "Transaction finished with status: " + status
    
    # Безопасное логирование с использованием контекстного менеджера context manager
    with open("audit_log.txt", "w") as file:
        file.write(log_entry)
        
    return status
