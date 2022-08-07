-- Variables
local CommonNumbers             = {}
local SerializeDict, SerializeArr;

-- Constants
local MATH_HUGE                 = math.huge
local MATH_HUGE_NEG             = -MATH_HUGE
local CHAR_BYTE_MAP             = {}
local BYTE_CHAR_MAP             = {}

-- Generatee bytemaps
for Byte = 1, 255 do
    local Char = string.char(Byte)
    CHAR_BYTE_MAP[Char] = Byte
    BYTE_CHAR_MAP[Byte] = Char
end

-- Generate common numbers list
for i = -0xFF, 0xFF do
    CommonNumbers[i] = tostring(i)
end

-- Serializer functions
local function BeautifyString(String: string, BeautifyStrings: boolean)
    local New = ""
    for i = 1, #String do
        local Char = string.sub(String, i, i)
        local Code = CHAR_BYTE_MAP[Char]
        New ..= (Code < 32 or Code > 127) and "\\" .. Code or Char
    end
    return New
end
function SerializeArr(ToSerialze: table, BeautifyStrings: boolean)
    -- Initial variables
    local Result = {"{"}
    local Serialized = {}

    -- Go through it and be funny
    for i = 1, #ToSerialze do
        -- I hate this but cope
        local Value = ToSerialze[i];
        local FinalValue = Serialized[Value]

        -- Optimization
        if (FinalValue) then
            Result[#Result+1] = FinalValue
            Result[#Result+1] = ","
            continue
        end

        -- Serialize this value
        local VType = typeof(Value)
        local VIndex = #Result+1
        if (VType == "string") then
            Result[VIndex] = "\"" .. (BeautifyStrings and BeautifyString(Value) or Value) .. "\""
        elseif (VType == "boolean") then
            Result[VIndex] = (Value and "true" or "false")
        elseif (VType == "number") then
            Result[VIndex] = (Value ~= Value and "0/0" or Value == MATH_HUGE and "1/0" or Value == MATH_HUGE_NEG and "-1/0" or CommonNumbers[Value] or tostring(Value))
        elseif (VType == "table") then
            Result[VIndex] = (not next(Value)) and "{}" or (#Value == 0) and SerializeDict(Value) or SerializeArr(Value)
        end
        FinalValue = Result[VIndex]
        Result[VIndex+1] = ","

        -- Add finished thing :3
        if (not FinalValue) then continue end
        Serialized[Value] = FinalValue
    end

    -- WTF?!
    local Latest = Result[#Result]
    Result[#Result] = Latest:sub(1, -2)
    Result[#Result+1] = "}"
    return table.concat(Result)
end
function SerializeDict(ToSerialze: table, BeautifyStrings: boolean)
    -- Initial variables
    local Result = {"{"}
    local Serialized = {}

    -- Go through it and be funny
    for Key, Value in next, ToSerialze do
        -- I hate this but cope
        local FinalKey = CommonNumbers[Key] or Serialized[Key]
        local FinalValue = CommonNumbers[Value] or Serialized[Value]

        -- Optimization
        if (FinalKey and FinalValue) then
            Result[#Result+1] = "["
            Result[#Result+1] = FinalKey
            Result[#Result+1] = "]="
            Result[#Result+1] = FinalValue
            Result[#Result+1] = ","
            continue
        end

        -- Serialize this key
        Result[#Result+1] = "["
        local KType = typeof(Key)
        local KIndex = #Result+1
        if (KType == "string") then
            Result[KIndex] = "\"" .. (BeautifyStrings and BeautifyString(Key) or Key) ..  "\""
        elseif (KType == "boolean") then
            Result[KIndex] = (Key and "true" or "false")
        elseif (KType == "number") then
            Result[KIndex] = (Key ~= Key and "0/0" or Key == MATH_HUGE and "1/0" or Key == MATH_HUGE_NEG and "-1/0" or CommonNumbers[Key] or tostring(Key))
        elseif (KType == "table") then
            Result[KIndex] = (not next(Key)) and "{}" or (#Key == 0) and SerializeDict(Key) or SerializeArr(Key)
        end
        FinalKey = Result[KIndex]
        Result[KIndex+1] = "]="

        -- Serialize this value
        local VType = typeof(Value)
        local VIndex = #Result+1
        if (VType == "string") then
            Result[VIndex] = "\"" .. (BeautifyStrings and BeautifyString(Value) or Value) .. "\""
        elseif (VType == "boolean") then
            Result[VIndex] = (Value and "true" or "false")
        elseif (VType == "number") then
            Result[VIndex] = (Value ~= Value and "0/0" or Value == MATH_HUGE and "1/0" or Value == MATH_HUGE_NEG and "-1/0" or CommonNumbers[Value] or tostring(Value))
        elseif (VType == "table") then
            Result[VIndex] = (not next(Value)) and "{}" or (#Value == 0) and SerializeDict(Value) or SerializeArr(Value)
        end
        FinalValue = Result[VIndex]
        Result[VIndex+1] = ","

        -- Add finished thing :3
        if not (FinalKey and FinalValue) then continue end
        Serialized[FinalKey] = FinalValue
    end

    -- WTF?!
    local Latest = Result[#Result]
    Result[#Result] = Latest:sub(1, -2)
    Result[#Result+1] = "}"
    return table.concat(Result)
end

-- Return FUNCTIONS?!
return SerializeArr, SerializeDict