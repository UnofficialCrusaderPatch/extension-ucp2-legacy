-- The original keyboard handler owns mode checks and the speed notification.
-- Replace only its arithmetic branches when extended speeds are enabled.
return {
  init=function(self)
    self.up=core.AOBScan('83 F8 5A 0F 8D ? ? ? ? 83 C0 05 83 F8 5A A3 ? ? ? ? 7E 0A C7 05 ? ? ? ? 5A 00 00 00')
    self.down=core.AOBScan('0F 8E 0B F4 FF FF 83 E8 05 BF 14 00 00 00 3B C7 A3 ? ? ? ? 7D 8F 89 3D ? ? ? ? EB 87 3D')
    self.speed=core.readInteger(self.up+16)
    assert(self.speed==core.readInteger(self.down+17),'Speed keys use different state')
    self.done=self.up+9+core.readInteger(self.up+5)
    assert(self.done==self.down+6+core.readInteger(self.down+2),'Speed key returns differ')
  end,
  enable=function(self)
    local steps=require('port/speed-steps')
    for _,entry in ipairs({{self.up,1},{self.down,-1}}) do
      local code=steps.code(entry[2],self.speed,self.up+32,self.done)
      local address=core.allocateCode(core.calculateCodeSize(code))
      core.writeCode(address,code)
      core.writeCode(entry[1],{0xe9,core.relTo(address,-4),0x90})
    end
  end,
  disable=function() error('not implemented') end,
}
