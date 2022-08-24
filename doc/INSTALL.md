
## Installation 

### Fetch Source

```
git clone https://github.com/joe-opensrc/lua-entcom.git
```

### Manual Install

```
cd lua-entcom
cp -r entcom.lua entcom/utils.lua /path/to/your/lua/project/libraries
```

### Luarocks Install

```
cd lua-entcom
luarocks pack entcom-0.1-4.rockspec 
luarocks install entcom-0.1-4.src.rock # installs globally
```

or

```
luarocks install --to=/path/to/your/project entcom-0.1-4.src.rock 
```

Make sure to set the `package_path` correctly

e.g.,
`package.path = package.path .. ";share/lua/5.3/?.lua"`



