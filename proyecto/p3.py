from pycoingecko import CoinGeckoAPI
import json
import sys

numArgs = len(sys.argv)
cg = CoinGeckoAPI()


# jsonReponse = cg.get_price(ids=sys.argv[1], vs_currencies=sys.argv[2])
# string = json.dumps(jsonReponse)

# peticiones historico
# 1 2 3 opciones de menu 
fileName = 'json.json'
print("\nSelect a number to choose an api")
print("1: coins/Markets\n2: asset_platforms\n3: categories/list\n4: coins/categories\n5: exchanges\n6: finance/platforms\n7: finance/products\n8: indexes")
print("9: derivates/exchanges/list\n")
number = int(input())

def writeFile(arg1):
    with open(fileName,'w') as f:
        json.dump(arg1,f, indent=4)

if (number == 1) : 
    print("Select your currency\n")
    print("1: eur\n2:usd\n")
    vs_currency = int(input())
    if(vs_currency == 1):
        vs_currency = "eur"
    else:
        vs_currency = "usd"
    
    jsonReponse = cg.get_coins_markets(vs_currency=vs_currency)
    writeFile(jsonReponse)
    
elif (number == 2) : 
    jsonReponse = cg.get_asset_platforms()
    writeFile(jsonReponse)

elif (number == 3) :
    jsonReponse = cg.get_coins_categories_list()
    writeFile(jsonReponse)

elif (number == 4) : 
    jsonReponse = cg.get_coins_categories()
    writeFile(jsonReponse)

elif (number == 5):
    jsonReponse = cg.get_exchanges_list()
    writeFile(jsonReponse)

elif (number == 6):
    jsonReponse = cg.get_finance_platforms()
    writeFile(jsonReponse)

elif (number == 7):
    jsonReponse = cg.get_finance_products()
    writeFile(jsonReponse)

elif (number == 8):
    jsonReponse = cg.get_indexes()
    writeFile(jsonReponse)

elif (number == 9):
    jsonReponse = cg.get_derivatives_exchanges()
    writeFile(jsonReponse)
    