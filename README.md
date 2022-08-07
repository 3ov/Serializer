## Import
```lua
local SerializeDict, SerializeArr, SerializeBeauty = loadstring(syn.request({Url = "https://raw.githubusercontent.com/3ov/Serializer/main/Main.lua", Method  = "GET"}).Body)()
```

## Docs
```lua 
SerializeArr(ToSerialize: table, BeautifyStrings: boolean) -> string
```
Stringifies the array, the fastest of the functions.
```lua
SerializeDict(ToSerialize: table, BeautifyStrings: boolean) -> string
```
Stringifies the dictionary.
```lua
SerializeBeauty(ToSerialize: table, Indent: number) -> string
```
The slowest of the functions, adds indents to the result and beautifies strings by default
