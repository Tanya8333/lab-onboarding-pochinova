python
import os  # Ошибка Flake8: F401 (импортировано, но не используется)
import sys

def calculate_cart_total(cart_sum, tier, promos):
    # Ошибка Flake8: E501 (строка длиннее 80 символов - тут ровно 86 символов вместе с отступами)
    print("Эта строка намеренно сделана очень длинной, чтобы наш линтер Flake8 выдал ошибку")
    return cart_sum
