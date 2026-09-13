"""Execute the generated x86 speed branches without launching or patching a game."""
from pathlib import Path
import struct,unittest
from lupa import LuaRuntime
from unicorn import Uc,UC_ARCH_X86,UC_MODE_32,UC_HOOK_CODE
from unicorn.x86_const import UC_X86_REG_EAX,UC_X86_REG_EBX,UC_X86_REG_EDI,UC_X86_REG_ESP

class SpeedStepsTests(unittest.TestCase):
    def test_generated_branches_select_adjacent_values_and_preserve_caller_state(self):
        lua=LuaRuntime(); root=Path(__file__).resolve().parents[1]
        lua.globals().root=root.as_posix()
        lua.execute('''
package.path=root..'/?.lua;'..package.path
utils={itob=function(n) local t={}; for i=1,4 do t[i]=n%256; n=math.floor(n/256) end; return t end}
core={relTo=function(target,offset) assert(offset==-4); return {relative=target} end}
steps=require('port/speed-steps')
''')
        values=list(lua.globals().steps['values'].values())
        self.assertEqual(values[18:],[100,125,150,175,200,300,500,1000,1100])
        for direction in (-1,1):
            output=bytearray()
            def emit(value):
                if isinstance(value,(int,float)): output.append(int(value))
                elif value['relative'] is not None:
                    output.extend(struct.pack('<i',int(value['relative'])-(0x10000+len(output)+4)))
                else:
                    for child in value.values(): emit(child)
            emit(lua.globals().steps.code(direction,0x20000,0x30000,0x30010))
            machine=Uc(UC_ARCH_X86,UC_MODE_32); machine.mem_map(0x10000,0x30000)
            machine.mem_write(0x10000,bytes(output))
            end=[]
            def stop(m,address,size,data):
                if address in (0x30000,0x30010): end.append(address); m.emu_stop()
            machine.hook_add(UC_HOOK_CODE,stop)
            for current in [*range(0,1201),10000]:
                end.clear(); machine.mem_write(0x20000,struct.pack('<I',current))
                machine.reg_write(UC_X86_REG_EAX,current)
                for reg,value in ((UC_X86_REG_EBX,55),(UC_X86_REG_EDI,77),(UC_X86_REG_ESP,0x3f000)):
                    machine.reg_write(reg,value)
                machine.emu_start(0x10000,0x30020,count=1000)
                eligible=[v for v in values if (v-current)*direction>0]
                expected=(min(eligible) if direction==1 else max(eligible)) if eligible else current
                self.assertEqual(struct.unpack('<I',machine.mem_read(0x20000,4))[0],expected)
                self.assertEqual(end,[0x30000 if eligible else 0x30010])
                self.assertEqual(machine.reg_read(UC_X86_REG_EBX),55)
                self.assertEqual(machine.reg_read(UC_X86_REG_EDI),77)
                self.assertEqual(machine.reg_read(UC_X86_REG_ESP),0x3f000)
