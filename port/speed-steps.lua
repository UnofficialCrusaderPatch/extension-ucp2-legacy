-- Shared by the generated native +/- branches. Presentation only; the existing
-- keyboard guards still decide when and who may change speed.
local M={values={10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,
  100,125,150,175,200,300,500,1000,1100}}

-- EAX contains the current speed. Select the adjacent step, then leave the
-- native caller's other registers and stack untouched. No Lua runs on keypress.
function M.code(direction,speedAddress,notify,unchanged)
  assert(direction==1 or direction==-1)
  local code={}
  local function emit(...) for _,v in ipairs({...}) do code[#code+1]=v end end
  for index=1,#M.values do
    local value=M.values[direction==1 and index or #M.values-index+1]
    emit(0x3d,utils.itob(value)) -- cmp eax,value
    emit(direction==1 and 0x7d or 0x7e,15) -- skip assignment when not adjacent
    emit(0xb8,utils.itob(value),0xa3,utils.itob(speedAddress),0xe9,core.relTo(notify,-4))
  end
  emit(0xe9,core.relTo(unchanged,-4))
  return code
end
return M
