function printInfo()
  gamestate = emu.read(0x000E, 'memType.cpuDebug', false)
  need_new_cones = emu.read(0x005D, 'memType.cpuDebug', false)
  need_remove_cones = emu.read(0x005E, 'memType.cpuDebug', false)
  ball_box = emu.read(0x0033, 'memType.cpuDebug', false)
  ball_box_old = emu.read(0x0034, 'memType.cpuDebug', false)
  
  car_box = emu.read(0x0045, 'memType.cpuDebug', false)
  car_position = emu.read(0x0058, 'memType.cpuDebug', false)
  car_box_old = emu.read(0x0046, 'memType.cpuDebug', false)
  car_position_old = emu.read(0x0059, 'memType.cpuDebug', false)
  
  emu.drawString(12, 12, "Gamestate: " .. gamestate, 0xFFFFFF, 0xFF000000, 1)
  emu.drawString(12, 21, "needCones: " .. need_new_cones, 0xFFFFFF, 0xFF000000, 1)
  emu.drawString(12, 30, "needRemoveCones: " .. need_remove_cones, 0xFFFFFF, 0xFF000000, 1)
  emu.drawString(12, 39, "ballBox: " .. ball_box, 0xFFFFFF, 0xFF000000, 1)
  emu.drawString(12, 48, "ballBoxOld: " .. ball_box_old, 0xFFFFFF, 0xFF000000, 1)
  
  emu.drawString(120, 12, "car_box: " .. car_box, 0xFFFFFF, 0xFF000000, 1)
  emu.drawString(120, 21, "car_box_old: " .. car_box_old, 0xFFFFFF, 0xFF000000, 1)
  emu.drawString(120, 30, "car_position: " .. car_position, 0xFFFFFF, 0xFF000000, 1)
  emu.drawString(120, 39, "car_position_old: " .. car_position_old, 0xFFFFFF, 0xFF000000, 1)
end

emu.addEventCallback(printInfo, emu.eventType.endFrame);
emu.displayMessage("Script", "First LUA script loaded!")