FROM ubuntu
RUN apt-get update
RUN apt-get install curl sudo --yes
RUN curl https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc
RUN curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
#RUN /bin/yes | apt-get install mssql-tools18 unixodbc-dev --yes
#RUN echo yes | apt -o Apt::Get::Assume-Yes=true install mssql-tools18
RUN apt-get install unixodbc-dev --yes

RUN apt-get install expect --yes
RUN echo "#!/usr/bin/expect -f" > /root/install_mssql-tools18
RUN echo "set timeout -1" >> /root/install_mssql-tools18
RUN echo "spawn apt-get install mssql-tools18 --yes" >> /root/install_mssql-tools18
RUN echo 'expect "yes/no"' >> /root/install_mssql-tools18
RUN echo "sleep 1" >> /root/install_mssql-tools18
RUN echo 'send -- "yes\\r"' >> /root/install_mssql-tools18
RUN echo 'expect "yes/no"' >> /root/install_mssql-tools18
RUN echo "sleep 1" >> /root/install_mssql-tools18
RUN echo 'send -- "yes\\r"' >> /root/install_mssql-tools18
RUN chmod 755 /root/install_mssql-tools18
RUN /root/install_mssql-tools18

RUN echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> /root/.bashrc
