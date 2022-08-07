-- Variables
local CommonNumbers             = {}
local SerializeDict, SerializeArr;

-- Constants
local MATH_HUGE                 = math.huge
local MATH_HUGE_NEG             = -MATH_HUGE

-- Generate common numbers list
for i = -0xFF, 0xFF do
    CommonNumbers[i] = tostring(i)
end

-- Serializer functions
local function BeautifyString(String: string, BeautifyStrings: boolean)
    local New = ""
    for i = 1, #String do
        local Char = string.sub(String, i, i)
        local Code = string.byte(Char)
        New ..= (Code < 32 or Code > 127) and "\\" .. Code or Char
    end
    return New
end
function SerializeArr(ToSerialze: table, BeautifyStrings: boolean)
    -- Initial variables
    local Result = "{" .. string.rep("%s,", #ToSerialze):sub(1, -2) .. "}"
    local Completed = {}
    local Serialized = {}

    -- Go through it and be funny
    for i = 1, #ToSerialze do
        -- I hate this but cope
        local Value = ToSerialze[i];
        local FinalValue;

        -- Optimization
        if (Serialized[Value]) then
            Completed[i] = Serialized[Value]
            continue
        end

        -- Serialize this value
        local VType = typeof(Value)
        FinalValue = FinalValue
            or (VType == "string") and "\"".. (BeautifyStrings and BeautifyString(Value) or Value) .. "\""
            or (VType == "boolean") and (Value and "true" or "false")
            or (VType == "number") and (Value ~= Value and "0/0" or Value == MATH_HUGE and "1/0" or Value == MATH_HUGE_NEG and "-1/0" or CommonNumbers[Value] or tostring(Value))
            or (VType == "table") and (#Value == 0 and not next(Value)) and "{}" or (#Value == 0) and SerializeDict(Value) or SerializeArr(Value)

        -- Add finished thing :3
        if (not FinalValue) then continue end
        Completed[i] = FinalValue
        Serialized[Value] = FinalValue
    end

    -- WTF?!
    return string.format(Result, unpack(Completed))
end
function SerializeDict(ToSerialze: table, BeautifyStrings: boolean)
    -- Initial variables
    local Result = "{"
    local Serialized = {}

    -- Go through it and be funny
    for Key, Value in next, ToSerialze do
        -- I hate this but cope
        local FinalKey = CommonNumbers[Key] or Serialized[Key]
        local FinalValue = CommonNumbers[Value] or Serialized[Value]

        -- Optimization
        if (FinalKey and FinalValue) then
            Result ..= ("[" .. FinalKey .. "]=" .. FinalValue .. ",")
            continue
        end

        -- Serialize this key
        local KType = typeof(Key)
        FinalKey = FinalKey
            or (KType == "string") and "\"".. (BeautifyStrings and BeautifyString(Key) or Key) .. "\""
            or (KType == "boolean") and (Key and "true" or "false")
            or (KType == "number") and (Key ~= Key and "0/0" or Key == MATH_HUGE and "1/0" or Key == MATH_HUGE_NEG and "-1/0" or CommonNumbers[Key] or tostring(Key))
            or (KType == "table") and (#Key == 0 and not next(Key)) and "{}" or (#Key == 0) and SerializeDict(Key) or SerializeArr(Key)

        -- Serialize this value
        local VType = typeof(Value)
        FinalValue = FinalValue
            or (VType == "string") and "\"".. (BeautifyStrings and BeautifyString(Value) or Value) .. "\""
            or (VType == "boolean") and (Value and "true" or "false")
            or (VType == "number") and (Value ~= Value and "0/0" or Value == MATH_HUGE and "1/0" or Value == MATH_HUGE_NEG and "-1/0" or CommonNumbers[Value] or tostring(Value))
            or (VType == "table") and (#Value == 0 and not next(Value)) and "{}" or (#Value == 0) and SerializeDict(Value) or SerializeArr(Value)

        -- Add finished thing :3
        if not (FinalKey and FinalValue) then continue end
        Result ..= ("[" .. FinalKey .. "]=" .. FinalValue .. ",")
        Serialized[FinalKey] = FinalValue
    end

    -- WTF?!
    return Result:sub(1, -2) .. "}"
end

-- Return FUNCTIONS?!
return SerializeArr, SerializeDict