FROM kalilinux/kali-linux-docker

RUN apt-get update
RUN apt-get upgrade --yes

RUN apt-get install vim metasploit-framework --yes
RUN apt-get install set --yes

RUN apt-get install net-tools --yes

RUN apt-get install openssh-server --yes
RUN echo '# Added at docker build time\nMatch Address 172.17.0.0/16\n\tPermitRootLogin yes' >> /etc/ssh/sshd_config
RUN service ssh start

RUN mkdir /root/.ssh
RUN chmod 600 /root/.ssh
ADD id_*.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

ENTRYPOINT service ssh restart && /bin/bash
