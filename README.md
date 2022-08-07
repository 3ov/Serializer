**Docs**
<br/>
```lua 
SerializeArr(ToSerialize: table, BeautifyStrings: boolean) -> string
```
\n
Stringifies the array, the fastest of the functions.
\n
```lua
SerializeDict(ToSerialize: table, BeautifyStrings: boolean) -> string
```
\n
Stringifies the dictionary.
\n
```lua
SerializeBeauty(ToSerialize: table, Indent: number) -> string
```
\n
The slowest of the functions, adds indents to the result and uses beautifystrings by default
