include.file("Util.lua")

NetManager = { }

function NetManager.open(channel, modemSide)
  NetManager.modem = peripheral.wrap(modemSide)
  NetManager.modem.open(channel)
  NetManager.channel = channel
  NetManager.modemSide = modemSide
end

function NetManager.send(id, message)
  local modem = NetManager.modem
  if not modem then error("Modem not initialized.") end
  local channel = NetManager.channel

  message.__SENDER = os.computerID()
  message.__SENDER_TYPE = "SLAVE"
  message.__RECIPIENT = id
  local data = Util.encodeNetData(textutils.serialize(message))
  modem.transmit(channel, channel, data)
end

function NetManager.receive()
  local message
  while not message do
    local _, _, _, _, data, _ = os.pullEvent("modem_message")
    message = textutils.unserialize(Util.decodeNetData(data))

    if not message or message.__RECIPIENT ~= os.computerID() then
      message = nil
    end
  end

  return message
end