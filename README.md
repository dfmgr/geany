## geany  
  
DESCRIBE  
  
Automatic install/update:

```shell
bash -c "$(curl -LSs https://github.com/dfmgr/geany/raw/main/install.sh)"
```

Manual install:
  
requires:

Debian based:

```shell
apt install geany
```  

Fedora Based:

```shell
yum install geany
```  

Arch Based:

```shell
pacman -S geany
```  

MacOS:  

```shell
brew install geany
```
  
```shell
mv -fv "$HOME/.config/geany" "$HOME/.config/geany.bak"
git clone https://github.com/dfmgr/geany "$HOME/.config/geany"
```
  
<p align=center>
  <a href="https://wiki.archlinux.org/index.php/geany" target="_blank" rel="noopener noreferrer">geany wiki</a>  |  
  <a href="https://www.geany.org" target="_blank" rel="noopener noreferrer">geany site</a>
</p>  
