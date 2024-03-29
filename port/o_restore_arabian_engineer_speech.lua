local writeCode = core.writeCode
local writeBytes = core.writeBytes
local AOBScan = core.AOBScan
local compile = core.compile
local calculateCodeSize = core.calculateCodeSize
local allocate = core.allocate
local allocateCode = core.allocateCode
local getRelativeAddress = core.getRelativeAddress
local relTo = core.relTo
local relToLabel = core.relToLabel
local byteRelTo = core.byteRelTo
local readInteger = core.readInteger

local itob = utils.itob
local smallIntegerToBytes = utils.smallIntegerToBytes

-- B4EBE0 + 4 * 18   (vanilla = 15000)
-- ladderman: 0xB55AF4 = soldier bool
--____NEW CHANGE: o_restore_arabian_engineer_speech
return {

    init = function(self, config)
        self.o_restore_arabian_engineer_speech_lord_type_edit = AOBScan("C7 05 ? ? ? ? 00 00 00 00 7D 71 C7 05 ? ? ? ? 02 00 00 00 C3 83 F8 16")
        self.o_restore_arabian_engineer_speech_edit = AOBScan("C7 01 00 00 00 00 03 DA 6B DB 25 03 D8 8B 14 9D ? ? ? ? 52 8D 44 24 0C 68 ? ? ? ? 50")
        self.o_restore_arabian_engineer_speech_purchase_edit = AOBScan("83 3D ? ? ? ? 02 75 13 8B 86 ? ? ? ? 50 68 ? ? ? ? 8D 4C 24 10 51 EB 11 8B 96 ? ? ? ? 52")
        -- 466EC9
        self.o_restore_arabian_engineer_speech_engine_edit = AOBScan("75 07 68 ? ? ? ? EB 05 68 ? ? ? ? E8 ? ? ? ? 89 35 ? ? ? ? FF D7 A3 ? ? ? ? 5F 5E C3")
    end,

    enable = function(self, config)
        
        -- new DefaultHeader("o_restore_arabian_engineer_speech")
        local SelectedLordType = readInteger(self.o_restore_arabian_engineer_speech_lord_type_edit + 2)
        local code = {
                0x61, 0x65, 0x6E, 0x67, 0x69, 0x6E, 0x65, 0x65, 0x72, 0x5F, 0x73, 0x31, 0x2E, 0x77, 0x61, 0x76, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x61, 0x65, 0x6E, 0x67, 0x69, 0x6E, 0x65, 0x65, 0x72, 0x5F, 0x73, 0x32, 0x2E, 0x77, 0x61, 0x76, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x61, 0x65, 0x6E, 0x67, 0x69, 0x6E, 0x65, 0x65, 0x72, 0x5F, 0x73, 0x31, 0x2E, 0x77, 0x61, 0x76, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x61, 0x65, 0x6E, 0x67, 0x69, 0x6E, 0x65, 0x65, 0x72, 0x5F, 0x73, 0x32, 0x2E, 0x77, 0x61, 0x76, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x61, 0x65, 0x6E, 0x67, 0x69, 0x6E, 0x65, 0x65, 0x72, 0x5F, 0x73, 0x31, 0x2E, 0x77, 0x61, 0x76, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x61, 0x65, 0x6E, 0x67, 0x69, 0x6E, 0x65, 0x65, 0x72, 0x5F, 0x73, 0x32, 0x2E, 0x77, 0x61, 0x76, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x61, 0x65, 0x6E, 0x67, 0x69, 0x6E, 0x65, 0x65, 0x72, 0x5F, 0x6D, 0x31, 0x2E, 0x77, 0x61, 0x76, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x61, 0x65, 0x6E, 0x67, 0x69, 0x6E, 0x65, 0x65, 0x72, 0x5F, 0x6D, 0x31, 0x2E, 0x77, 0x61, 0x76, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x61, 0x65, 0x6E, 0x67, 0x69, 0x6E, 0x65, 0x65, 0x72, 0x5F, 0x6D, 0x31, 0x2E, 0x77, 0x61, 0x76, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x61, 0x65, 0x6E, 0x67, 0x69, 0x6E, 0x65, 0x65, 0x72, 0x5F, 0x6D, 0x32, 0x2E, 0x77, 0x61, 0x76, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x61, 0x65, 0x6E, 0x67, 0x69, 0x6E, 0x65, 0x65, 0x72, 0x5F, 0x6D, 0x33, 0x2E, 0x77, 0x61, 0x76, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x61, 0x65, 0x6E, 0x67, 0x69, 0x6E, 0x65, 0x65, 0x72, 0x5F, 0x6D, 0x6F, 0x61, 0x74, 0x31, 0x2E, 0x77, 0x61, 0x76, 0x00, 0x00, 0x00, 0x00, 0x00, 0x61, 0x65, 0x6E, 0x67, 0x69, 0x6E, 0x65, 0x65, 0x72, 0x5F, 0x6D, 0x6F, 0x61, 0x74, 0x31, 0x2E, 0x77, 0x61, 0x76, 0x00, 0x00, 0x00, 0x00, 0x00, 0x61, 0x65, 0x6E, 0x67, 0x69, 0x6E, 0x65, 0x65, 0x72, 0x5F, 0x6D, 0x6F, 0x61, 0x74, 0x31, 0x2E, 0x77, 0x61, 0x76, 0x00, 0x00, 0x00, 0x00, 0x00, 0x61, 0x65, 0x6E, 0x67, 0x69, 0x6E, 0x65, 0x65, 0x72, 0x5F, 0x6D, 0x6F, 0x61, 0x74, 0x31, 0x2E, 0x77, 0x61, 0x76, 0x00, 0x00, 0x00, 0x00, 0x00, 0x61, 0x65, 0x6E, 0x67, 0x69, 0x6E, 0x65, 0x65, 0x72, 0x5F, 0x6D, 0x6F, 0x61, 0x74, 0x31, 0x2E, 0x77, 0x61, 0x76, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x61, 0x65, 0x6E, 0x67, 0x69, 0x6E, 0x65, 0x65, 0x72, 0x5F, 0x64, 0x69, 0x73, 0x62, 0x61, 0x6E, 0x64, 0x31, 0x2E, 0x77, 0x61, 0x76, 0x00, 0x00, 
        }
        local ArabianEngineerWavs = allocate(calculateCodeSize(code))
        writeBytes(ArabianEngineerWavs, compile(code,ArabianEngineerWavs))
        local OriginalWavFileAddressArray = readInteger(self.o_restore_arabian_engineer_speech_edit + 0 + 0 + 6 + 10)
        local code = {
            0xE9, function(address, index, labels)
                local hook = {
                    0x3D, 0x0A, 0x00, 0x00, 0x00,  -- cmp eax,0A
                    0x75, 0x1C,  -- jne short 1C
                    0x81, 0x3D, itob(SelectedLordType), 0x01, 0x00, 0x00, 0x00,  -- cmp [SelectedLordType],00000001
                    0x75, 0x10,  -- jne short 10
                    0x01, 0xD3,  -- add ebx,edx
                    0x69, 0xDB, 0x18, 0x00, 0x00, 0x00,  -- imul ebx,ebx,00000018
                    0x8D, 0x93, itob(ArabianEngineerWavs),  -- lea edx,[ebx+ArabianEngineerWavs]
                    0xEB, 0x0E,  -- jmp short E
                    0x01, 0xD3,  -- add ebx,edx
                    0x6B, 0xDB, 0x25,  -- imul ebx,ebx,25
                    0x01, 0xC3,  -- add ebx,eax
                    0x8B, 0x14, 0x9D, itob(OriginalWavFileAddressArray),  -- mov edx,[ebx*4+OriginalWavFileAddressArray]
                    0xe9, relTo(self.o_restore_arabian_engineer_speech_edit + 0 + 0 + 6 + 14, -4)
                }
                local hookSize = calculateCodeSize(hook)
                local hookAddress = allocateCode(hookSize)
                writeCode(hookAddress, hook)
                return itob(getRelativeAddress(address, hookAddress, -4))
            end,
            0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90
        }
        writeCode(self.o_restore_arabian_engineer_speech_edit + 0 + 0 + 6, code)
        local code = {
            0x83, 0x3D, itob(SelectedLordType), 0x01, 
        }
        writeCode(self.o_restore_arabian_engineer_speech_purchase_edit, code)
        local OriginalEngineerWavAddress = readInteger(self.o_restore_arabian_engineer_speech_engine_edit + 0 + 9 + 1)
        local code = {
            0xE9, function(address, index, labels)
                local hook = {
                    0x81, 0x3D, itob(SelectedLordType), 0x01, 0x00, 0x00, 0x00,  -- cmp [SelectedLordType],00000001
                    0x75, 0x07,  -- jne short 0x07
                    0x68, itob(ArabianEngineerWavs),  -- push ArabianEngineerWavs
                    0xEB, 0x05,  -- jmp short 0x05
                    0x68, itob(OriginalEngineerWavAddress),  -- push OriginalEngineerWavAddress
                    0xe9, relTo(self.o_restore_arabian_engineer_speech_engine_edit + 0 + 9 + 5, -4)
                }
                local hookSize = calculateCodeSize(hook)
                local hookAddress = allocateCode(hookSize)
                writeCode(hookAddress, hook)
                return itob(getRelativeAddress(address, hookAddress, -4))
            end,
        }
        writeCode(self.o_restore_arabian_engineer_speech_engine_edit + 0 + 9, code)
    end,

    disable = function(self, config)
        error("not implemented")
    end,

}
