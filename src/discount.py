python
def calculate_cart_total(cart_sum, tier, promos):
    """Рассчитывает финальную стоимость корзины с учетом скидок."""
    price = cart_sum   
    if cart_sum > 15000:
        price = cart_sum * 0.85
    for p in promos:
        if p == "SUMMER":
            price = price - 500
        elif p == "VIP":
            price = price * 0.90
    if tier == 1:
        price = price * 0.97
    elif tier == 2:
        price = price * 0.93
    if price < cart_sum * 0.70:
        price = cart_sum * 0.70 

    return price
