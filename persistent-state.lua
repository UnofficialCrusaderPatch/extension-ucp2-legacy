-- Mutable feature data belongs to the saved world, just like native unit data.
-- Register only values that survive a simulation call. Temporary call scratch,
-- presentation state and configuration tables do not belong in the save.
local M = {}

---@class PersistentFeatureBlock
---@field name string
---@field address integer
---@field size integer
---@field validate fun(data: string)|nil

---@class PersistentFeatureState
---@field blocks PersistentFeatureBlock[]
local State = {}
State.__index = State

function M.new()
    return setmetatable({blocks = {}}, State)
end

---@param name string Stable name within version 1 of the save layout.
---@param size integer Number of owned bytes, independent of the allocation address.
---@param validate fun(data: string)|nil Check before any saved blocks are applied.
---@return integer address
function State:allocate(name, size, validate)
    assert(type(name) == 'string' and name:match('^[a-z][a-z-]+$'), 'Invalid feature state name')
    assert(type(size) == 'number' and size > 0 and size % 1 == 0, 'Invalid feature state size')
    for _, block in ipairs(self.blocks) do
        assert(block.name ~= name, 'Duplicate feature state: ' .. name)
    end
    local address = core.allocate(size, true)
    self.blocks[#self.blocks + 1] = {name = name, address = address, size = size, validate = validate}
    return address
end

function State:initialize()
    for _, block in ipairs(self.blocks) do
        core.setMemory(block.address, 0, block.size)
    end
end

function State:serialize(handle)
    handle:put('format', '1')
    for _, block in ipairs(self.blocks) do
        local data = core.readString(block.address, block.size)
        assert(#data == block.size, 'Incomplete feature state: ' .. block.name)
        if block.validate then block.validate(data) end
        handle:put(block.name .. '.bin', data)
    end
end

function State:deserialize(handle)
    -- Original maps and older saves have no UCP2 section. Start from the same
    -- zero state as a fresh process instead of inheriting the previous match.
    if not handle:exists('format') then self:initialize(); return end
    assert(handle:get('format') == '1', 'Unsupported UCP2 feature save format')
    local pending = {}
    for index, block in ipairs(self.blocks) do
        local path = block.name .. '.bin'
        local data = handle:exists(path) and handle:get(path) or string.rep('\0', block.size)
        assert(type(data) == 'string' and #data == block.size, 'Invalid saved feature state: ' .. block.name)
        if block.validate then block.validate(data) end
        pending[index] = data
    end
    -- Decode everything before writing. core.writeBytes accepts a byte table,
    -- not a binary string, in the supported UCP 3.0.7 runtime.
    for index, block in ipairs(self.blocks) do
        local data, bytes = pending[index], {}
        for i = 1, #data do bytes[i] = data:byte(i) end
        core.writeBytes(block.address, bytes)
    end
end

return M
