local net = require("net")
local wifi = require("wifi")

local config = require("config")

local module = {}

local pageBody = [[
  <!DOCTYPE HTML>
  <html>
    <head>
      <meta content="text/html; charset=utf-8">
      <title>Good morning sunshine</title>
      <style type="text/css">
        html, body {
          min-height: 100%;
        }
        body {
          font-family: monospace;
          background: #5656fa;
          background-size: cover;
          margin: 0;
          padding: 10px;
          text-align: center;
          color: #56f2ff;
        }
        h1 { font-size: 15rem; }
      </style>
    </head>
    <body>
      <div><h1>Hello!</h1></div>
    </body>
  </html>
]]

local function runServer()
  local s = net.createServer(net.TCP)
  print("====================================")
  print("Server Started")
  print("Open " .. wifi.ap.getip() .. " in your browser")
  print("====================================")

  s:listen(config.PORT, function(connection)
    connection:on("receive", function(c, request)
      local path = request:match("^GET (.+) HTTP/")
      print(path)
      print(request)
      if path == '/' or path == "/hotspot-detect.html" then
        c:send(table.concat ({
            "HTTP/1.1 200 OK",
            "Content-Type: text/html",
            "Content-length: " .. #pageBody,
            "",
            pageBody
          }, "\r\n"))
      end
    end)

    connection:on("sent", function(c) 
        print("sent")
        c:close() 
      end)
  end)
end

function module.start()
  runServer()
end

return module
