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
```py
import json
from web3 import Web3

# w3 = Web3(Web3.HTTPProvider('http://127.0.0.1:8545'))
w3 = Web3(Web3.EthereumTesterProvider())
```
## <span id="deploy">Despliegue</span>
