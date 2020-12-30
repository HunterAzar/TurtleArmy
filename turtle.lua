--------globalne zmienne
imie = "brak"
getJob = 0
os.setComputerLabel(imie.." - oczekuje")
x = 0
y = 0
z = 0
lookAt = 1

developTest = 1

------------- funckcja sleep
function sleep(a)
    local sec = tonumber(os.clock() + a); 
    while (os.clock() < sec) do 
    end 
end


-------------- setInterval może się przyda xD
-- Magiczny ciąg bajtów b"x08/xa1/x01/x00/x00/x00/xb3"

-- z neta rzeczy xD
function getItemIndex(itemName)
	for slot = 1, 16, 1 do
		local item = turtle.getItemDetail(slot)
		if(item ~= nil) then
			if(item["name"] == itemName) then
				return slot
			end
		end
	end
end

function checkSend(wbs,exist,blocky,xx,yy,zz)
    block = blocky.name
    print(block)
    if exist~=false then
        ws.send("{\"typ\":\"spr\",\"block\":\""..block.."\",\"x\":"..xx..",\"y\":"..yy..",\"z\":"..zz.."}")
    end
end

function goCheck(ws,ile)
    blocks = {}
    ws.send("sprawdzanko")
    for i=0,ile,1 do
        gg, ggg = turtle.inspectDown()
        checkSend(ws,gg,ggg,x,y-1,z)
        gg, ggg = turtle.inspect()
        checkSend(ws,gg,ggg,x+1,y,z)
        gg, ggg = turtle.inspectUp()
        checkSend(ws,gg,ggg,x,y+1,z)
        turtle.turnLeft()
        gg, ggg = turtle.inspect()
        checkSend(ws,gg,ggg,x,y,z-1)
        turtle.turnRight()
        turtle.turnRight()
        gg, ggg = turtle.inspect()
        checkSend(ws,gg,ggg,x,y,z+1)
        turtle.turnLeft()
        gg, ggg = turtle.inspect()
        if gg==false then
            print("ide")
            turtle.forward()
            x=x+1
        else
            print("Nie ide blok "..ggg.name.." przede mna")
        end
    end
end

---------------websocket


function websockets()
    errr=5
    ws, err = http.websocket("ws://localhost:9878")
    while (errr~=0) do
        if err then
            print(err)
            local seco = 5-errr
            os.setComputerLabel(imie.." - blad serwera")
            print("Do zakończenia nasłuchiwania pozostało: "..tostring(seco).." sekund")
            errr=errr-1
            sleep(1)
            break
        elseif (ws) then
            term.clear()
            term.setCursorPos(1,1)
            print("AutoTurtleOS v0.0.1")
            print("Nawiazano polaczenie!!!!")
            if(imie == "brak") then
                print("Uzyskiwanie imienia")
                sleep(1)
                ws.send("imie")
            else
                getJob=getJob+1
                print("getJob"..tostring(getJob))
                ws.send("getjob")
            end
            local txt = ws.receive()
            if txt == nil then
                break
            end
            local command = {}
            local s= 1
            for word in txt:gmatch('[^,%s]+') do
                command[s]=word
                s=s+1
            end
            print(txt)
            print(command[1])
            local typ = command[1]
            local value = command[2]
            if developTest == 1 then
                print("juhu")
                goCheck(ws,5)
                ws.send("{develop:1}")
                ws.send("{gps:["..x..","..y..","..z.."]}")
            end
            if typ == 'rusz' then
                print("ruszam")
                ws.send(typ)
                os.setComputerLabel(imie.." - ruszam")
            elseif typ == "automat" then
                print("automatyczne kopanie")
                ws.send(typ)
                os.setComputerLabel(imie.." - kopie")
            elseif typ == "tunel" then
                print("kopię tunel")
                ws.send(typ)
                os.setComputerLabel(imie.." - kopie tunel")
            elseif typ == "wykonaj" then
                print("wykonuję polecenie")
                ws.send(typ)
                os.setComputerLabel(imie.." - wykonuje")
            elseif typ == "imie" then
                imie = value
                os.setComputerLabel(value)
                print("Moja nowe imie to: "..value)
            elseif typ == "gps" then
                os.setComputerLabel(imie.." - GPS")
                ws.send("{"..x..","..y..","..z.."}");
            elseif typ == "nic" then
                os.setComputerLabel(imie.." - wolny strzelec")
            end
        end
        
    end
    ws.close()
end

------------ Główna pętla --------------

while true do
    websockets()
    print("Ponowna próba łącza za 5s")
    sleep(5)
    print("No i git")
end