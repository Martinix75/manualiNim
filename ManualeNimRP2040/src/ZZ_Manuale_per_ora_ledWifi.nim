import std/[os, strutils]
import pico/gpio
import pico/cyw43
import pico/tcp

# Configura il LED sul Pico W
let led = gpio(15)

# Configura la connessione Wi-Fi
let ssid = "IlTuoSSID"
let password = "LaTuaPassword"

# Configura il server HTTP
proc handleClient(client: TcpSocket) =
    let request = client.recv(1024).str
    echo "Richiesta ricevuta: ", request

    if "/led/on" in request:
        led.high()  # Accendi LED
        echo "LED acceso"
    elif "/led/off" in request:
        led.low()  # Spegni LED
        echo "LED spento"

    # Risposta HTTP
    let response = """
        HTTP/1.1 200 OK
        Content-Type: text/html

        <html><body>
        <h1>Controllo LED</h1>
        <a href="/led/on">Accendi LED</a><br>
        <a href="/led/off">Spegni LED</a>
        </body></html>
    """
    client.send(response)

proc main() =
    cyw43Init()
    echo "Connessione a Wi-Fi..."
    cyw43Connect(ssid, password)

    let server = TcpServer(80)
    echo "Server in esecuzione!"

    while true:
        if let client = server.accept():
            handleClient(client)
            client.close()

main()
