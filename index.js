const http = require('http');
const fs = require('fs');
var path = require('path');
const WebSocketServer = require('websocket').server;
const { type } = require('os');
const server = http.createServer();
var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database('sqlite.db');
server.listen(9878);
const wsServer = new WebSocketServer({
    httpServer: server
});
turtle = [];
turtles = [];
names = ["Tobiasz","Hunter","Łukasz","Wakanda","Walera-Chan"];
console.log("GIT");
wsServer.on('request', function(request) {
    const connection = request.accept(null, request.origin);
    connection.on('message', function(message) {
        txt = message.utf8Data;
        if(message.utf8Data=="imie"){
            let name = names[0];
            names.shift;
            console.log("Nazwyam cię "+name);
            connection.send(`imie,`+name);
            turtles.push({"nazwa":name,"x":0,"y":0,"z":0,"status":"unconnected"});
            turtle.push("gps,gps");
        }
        console.log(txt);
        if(txt == "getjob"){
            console.log("robota");
            if(turtle[0]){
                
                connection.send(turtle[0]);
                turtle.shift();
            }else{
                connection.send("nic,nic");
            }
        }
        try {
            console.log(typeof(txt));
            json = JSON.parse(txt);
            if(json.typ !=undefined){
                if(json.typ == "spr"){
                    xx = parseInt(json.x);
                    yy = parseInt(json.y);
                    zz = parseInt(json.z);
                    console.log("działam x db")
                    let xd = db.exec(`insert into blocks(x,y,z,name,foundBy) values(${xx},${yy},${zz},"${json.block}","Tobiasz")`);
                }
                if(json.typ == "client"){
                    if(json.cmd == "giveMap"){
                        db.each("select x,y,z,name from blocks",function(err,row){
                            connection.send(`{"typ":"jsonMap","x":${row.x},"y":${row.y},"z":${row.z},"name":"${row.name}"}`);
                        });
                    }
                    if(json.cmd == "deleteBlock"){
                        db.exec(`delete from blocks where x=${json.x} and y=${json.y} and z=${json.z} and name="${json.name}"`);
                    }
                }
            }
            
        } catch (error) {
            console.log("to chyba nie json "+error);
        }
    });
    connection.on('close', function(reasonCode, description) {
        console.log('Turtle rozłączony: '+description);
    });
});