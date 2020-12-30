local ws, err = http.websocket("wss://echo.websocket.org")
if ws then
  ws.send("Hello")
  print(ws.receive())
  ws.close()
end