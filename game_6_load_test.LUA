boardNum = 0

function printInfo()

  tempVar1 = emu.read(0x0047, 'memType.cpuDebug', false)
  tempVar2 = emu.read(0x0048, 'memType.cpuDebug', false)
  
  emu.drawString(12, 12, "tempVar1: " .. tempVar1, 0xFFFFFF, 0xFF000000, 1)
  emu.drawString(12, 21, "tempVar2: " .. tempVar2, 0xFFFFFF, 0xFF000000, 1)
  emu.drawString(12, 30, "Total: " .. tempVar1+tempVar2, 0xFFFFFF, 0xFF000000, 1)
  
end

function setRamBP()
  emu.write(0x00F2, boardNum, 'memType.cpu')
  boardNum= boardNum+1
end

function breakCode()
  emu.breakExecution()
end

--Register some code (printInfo function) that will be run at the end of each frame
emu.addMemoryCallback(printInfo, emu.memCallbackType.cpuWrite, 0x00F0, 0x00F0)
emu.addMemoryCallback(breakCode, emu.memCallbackType.cpuWrite, 0x0200, 0x0240)

--Display a startup message
emu.displayMessage("Script", "Game 6 Load Test Loaded.")