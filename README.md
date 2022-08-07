**Docs**
<br/>
```lua 
SerializeArr(ToSerialize: table, BeautifyStrings: boolean) -> string```
<br/>
Stringifies the array, the fastest of the functions.
<br/>
```lua
SerializeDict(ToSerialize: table, BeautifyStrings: boolean) -> string```
<br/>
Stringifies the dictionary.
<br/>
```lua
SerializeBeauty(ToSerialize: table, Indent: number) -> string```
<br/>
The slowest of the functions, adds indents to the result and uses beautifystrings by default
