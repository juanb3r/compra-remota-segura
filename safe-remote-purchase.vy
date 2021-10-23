# Correr la transacción:
# 1. El vendedor ofrece un articulo a la venta y deposita el 2 veces su valor.
#    Balance es 2x valor.
#    (1.1. El vendedor puede reclamar su deposito y cerrar la venta si no han
#    comprado aún el articulo.)
# 2. El comprador paga el articulo a su valor establecido pero adicionalmente debe
#    dejar un deposito seguro igual al valor del articulo.
#    Balance es 4x valor.
# 3. El vendedor envía el articulo.
# 4. El comprador confirma recepción del articulo. El deposito se le regresa.
#    1x valor.
#    El deposito (2x valor) + valor del articulo (1x valor) es regresado al vendedor.
#    Balance is 0.

value: public(uint256) # Valor del articulo
seller: public(address)
buyer: public(address)
unlocked: public(bool)
ended: public(bool)

@external
@payable
def __init__():
    assert (msg.value % 2) == 0
    self.value = msg.value / 2  # El vendedor inicializa el contrato
        # Realiza un deposito seguro de dos veces el valor del articulo.
    self.seller = msg.sender
    self.unlocked = True

@external
def abort():
    assert self.unlocked # Es el contrato aún reembolsable?
    assert msg.sender == self.seller # Solo el vendedor puede retornar
        # su deposito antes de que alguien compre el articulo.
    selfdestruct(self.seller) # Devuelve al vendedor y cancela el contrato.

@external
@payable
def purchase():
    assert self.unlocked    # Está aún abierto el contrato (Aún se encuentra
                            # el articulo a la venta?
    assert msg.value == (2 * self.value) # Es el valor correcto el de la compra?
    self.buyer = msg.sender
    self.unlocked = False

@external
def received():
    # 1. Condiciones
    assert not self.unlocked    # Fue el articulo comprado y está pendiente
                                # de confirmación por parte del comprador?
    assert msg.sender == self.buyer
    assert not self.ended

    # 2. Efectos
    self.ended = True

    # 3. Interacción
    send(self.buyer, self.value) # Devuelve el deposito al comprador (=value).
    selfdestruct(self.seller)   # Regresa al vendedor su deposito (=2*value) y
                                # el valor del articulo (=value).
