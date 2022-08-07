**Docs**
<br/>
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
The slowest of the functions, adds indents to the result and uses beautifystrings by default
