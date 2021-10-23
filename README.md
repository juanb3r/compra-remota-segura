# Compra remota segura
Este es un ejemplo de un contrato inteligente hecho con vyper, para la realización de una compra segura de un articulo, servicio u otros.

-   [Instalación](#installation)
-   [Compilación](#compilation)
-   [Despligue](#deploy)

## <span id="installation">Instalación</span> 
 
Antes que todo debemos tener instalado python dentro de nuestro equipo.

-   Creación del entorno de desarrollo

    ``` 
    $ python3 -m venv venv 
    ```

-   Activación del entorno de desarrollo

    Ubuntu/MacOs:

    ```
    $ . venv/bin/activate
    ```

    Windows:

    ```
    $ venv/scripts/activate
    ```

-   Instalación de dependencias

    Instalamos vyper:

    ```
    $ pip install vyper
    ```

    Instalamos dependencias y/o librerías

    ```
    $ pip install 'web3[tester]' 
    $ pip install ipython
    ```

## <span id="compilation">Compilación</span>

Con la ayuda de la librería vyper, podemos compilar nuestros contratos haciendo uso del binario o el binario mas el ABI.

-   Compilando el binario (Bytecode):
    
    Dentro de nuestra consola usamos los siguiente comandos:
    
    ```
    $ vyper safe-remote-purchase.by > bytecode.bin
    $ vyper -f abi safe-remote-purchase.by > abi.json
    ```
    
Con esos comandos sea crean el bytecode y el ABI


## <span id="deploy">Despliegue</span>

Para el despliegue haremos uso de ipython, que es un editor iteractivo en consola y nos ayudará a completar nuestra linea de código.

```
$ ipython
```

Luego en la consola de ipython podemos ejecutar código de python, y en este caso haremos uso de la librería web3

Hacemos nuestras importaciones

```py
import json
from web3 import Web3
```

Conexión

```py
# w3 = Web3(Web3.HTTPProvider('http://127.0.0.1:8545'))
w3 = Web3(Web3.EthereumTesterProvider())
w3.isConnected() # Debe retornar un True
```

Verificación cuentas y balances

```py
# Verificamos la listas de cuentas
w3.eth.accounts
# Para conocer la cantidad en cada cuenta (0 - 9)
w3.eth.getBalance(w3.eth.accounts[0])

# Información del último bloque
w3.eth.getBlock('latest')
```

Referenciar cuentas

```py
# Referenciamos las cuentas por medio de variables
acct_one = w3.eth.accounts[0]
acct_two = w3.eth.accounts[1]
acct_three = w3.eth.accounts[2]

# Este número corresponde a los wei
w3.eth.getBalance(acct_one) # Balance cuenta 1
w3.eth.getBalance(acct_two) # Balance cuenta 2
w3.eth.getBalance(acct_three) # Balance cuenta 3

# Para ver cuantos ether son, usamos la función de toWei
Web3.toWei(w3.eth.getBalance(acct_three), "ether")
```
Despliegue de contrato

```py
# Obtenemos nuestro bytecode del archivo
bytecode_file = open ('bytecode.bin','r')
bytecode = bytecode_file.read()
bytecode = bytecode[2:-1]
bytcode

# Obtenemos nuestra abi del archivo
abi_file = open('abi.json', 'r')
abi = json.loads(abi_file.read())
abi

# Creamos el contrato 

# Precio del articulo 5 ether

tx_hash = SafePurchase.constructor().transact(
    {'from': acct_one,
    'value': w3.toWei(10, 'ether')})

# Verificamos la transacción

w3.eth.getTransaction(tx_hash)

# Esperamos a que la transacción sea minada, y se obtenemos la recepción de la transacción

tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)

# Corroboramos el saldo de nuestro vendedor

w3.eth.get_balance(acct_one)

# Creamos el objeto para interactuar con nuestro contrato

safe_purchase = w3.eth.contract(
    address=tx_receipt.contractAddress,
    abi=abi )

# Ahora el objeto safe_purchase tiene las funciones con las que debemos interactuar

# Hacemos la compra del articulo con una dirección diferenta a la del propietario
# acct_two => comprador
safe_purchase.functions.purchase().transact({'from': acct_two, 'value': w3.toWei(10, 'ether')})

# El siguiente comando debe generarnos un error
safe_purchase.functions.purchase().transact({'from': acct_three, 'value': w3.toWei(10, 'ether')})

w3.eth.get_balance(acct_two) # cuenta del comprador
w3.eth.get_balance(acct_three) # cuenta del que quiso comprar y no pudo

# Aceptamos la recepción del articulo
safe_purchase.functions.received().transact({'from': acct_two})

# Final del ejercicio
```