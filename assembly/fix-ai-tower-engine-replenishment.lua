
local writeCode = core.writeCode
local scanForAOB = core.scanForAOB

-- 0x004D20A2
writeCode(scanForAOB("7E 0A C7 44 24 24 03 00 00 00 EB 12 3B FD 0F 8E 0B 03 00 00 EB 08 8D A4 24 00 00 00 00 90 8B 80"), {0xEB})