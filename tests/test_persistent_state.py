"""Exercise actual Lua save callbacks without a running game."""
from pathlib import Path
import unittest
from lupa.luajit21 import LuaRuntime

ROOT = Path(__file__).resolve().parents[1]


class PersistentStateTests(unittest.TestCase):
    def setUp(self):
        self.lua = LuaRuntime(encoding=None)
        self.lua.execute(b'''
            memory = {}; nextAddress = 4096; writes = 0
            core = {
                allocate = function(size, zero)
                    assert(zero == true)
                    local address = nextAddress; nextAddress = nextAddress + size
                    memory[address] = string.rep('\\0', size); return address
                end,
                readString = function(address, size) assert(#memory[address] == size); return memory[address] end,
                setMemory = function(address, value, size) memory[address] = string.rep(string.char(value), size) end,
                writeBytes = function(address, bytes)
                    assert(type(bytes) == 'table'); local data = {}
                    for i, value in ipairs(bytes) do data[i] = string.char(value) end
                    memory[address] = table.concat(data); writes = writes + 1
                end,
            }
            handle = {files = {}}
            function handle:put(name, data) self.files[name] = data end
            function handle:exists(name) return self.files[name] ~= nil end
            function handle:get(name) return assert(self.files[name]) end
        ''')
        self.lua.globals().factory = self.lua.execute((ROOT/'persistent-state.lua').read_bytes())

    def check(self, source):
        self.lua.execute(source.encode())

    def test_round_trip_binary_state_at_different_addresses(self):
        self.check('''
            source = factory.new()
            a = source:allocate('attack-target-cycle', 4)
            b = source:allocate('ladder-destinations', 120000)
            memory[a] = string.char(6,0,0,0)
            memory[b] = string.rep(string.char(0,255,1,128), 30000)
            source:serialize(handle)
            loaded = factory.new()
            x = loaded:allocate('attack-target-cycle', 4)
            y = loaded:allocate('ladder-destinations', 120000)
            assert(x ~= a and y ~= b)
            loaded:deserialize(handle)
            assert(memory[a] == memory[x] and memory[b] == memory[y])
        ''')

    def test_old_map_and_save_clear_previous_match_state(self):
        self.check('''
            state = factory.new(); a = state:allocate('attack-target-cycle', 4)
            memory[a] = string.char(6,0,0,0); state:deserialize(handle)
            assert(memory[a] == string.rep('\\0', 4))
            memory[a] = string.char(3,0,0,0); state:initialize()
            assert(memory[a] == string.rep('\\0', 4))
        ''')

    def test_bad_later_block_does_not_partially_restore(self):
        self.check('''
            state = factory.new(); a = state:allocate('attack-target-cycle', 4)
            b = state:allocate('ladder-destinations', 12)
            memory[a] = string.char(6,0,0,0); memory[b] = string.rep('x', 12)
            handle.files = {format='1', ['attack-target-cycle.bin']=string.rep('\\0',4), ['ladder-destinations.bin']='short'}
            assert(not pcall(state.deserialize, state, handle))
            assert(memory[a] == string.char(6,0,0,0) and memory[b] == string.rep('x',12) and writes == 0)
        ''')

    def test_newly_enabled_feature_starts_empty(self):
        self.check('''
            state = factory.new(); a = state:allocate('attack-target-cycle', 4)
            b = state:allocate('ladder-destinations', 12)
            memory[b] = string.rep('x',12)
            handle.files = {format='1', ['attack-target-cycle.bin']=string.char(2,0,0,0)}
            state:deserialize(handle)
            assert(memory[a] == string.char(2,0,0,0) and memory[b] == string.rep('\\0',12))
        ''')

    def test_unknown_format_is_rejected_without_writes(self):
        self.check('''
            state = factory.new(); state:allocate('attack-target-cycle',4)
            handle.files.format = '2'
            assert(not pcall(state.deserialize,state,handle) and writes == 0)
        ''')

    def test_validator_runs_before_saving_or_restoring(self):
        self.check('''
            state = factory.new()
            a = state:allocate('attack-target-cycle',4,function(data) assert(data:byte(1) < 7) end)
            memory[a] = string.char(7,0,0,0)
            assert(not pcall(state.serialize,state,handle))
            handle.files = {format='1', ['attack-target-cycle.bin']=string.char(8,0,0,0)}
            assert(not pcall(state.deserialize,state,handle) and writes == 0)
        ''')

    def test_duplicate_registration_is_rejected(self):
        self.check('''
            state = factory.new(); state:allocate('attack-target-cycle',4)
            assert(not pcall(state.allocate,state,'attack-target-cycle',4))
        ''')

    def test_empty_feature_set_has_valid_save_callbacks(self):
        self.check('''
            state = factory.new(); state:initialize(); state:serialize(handle)
            assert(handle.files.format == '1'); state:deserialize(handle); assert(writes == 0)
        ''')


if __name__ == '__main__':
    unittest.main()
