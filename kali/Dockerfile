FROM kalilinux/kali-rolling
ARG ARCH

RUN apt-get update
RUN apt-get upgrade --yes
RUN apt-get install apt-utils --yes

# Needed for msfconsole SSL scans:
RUN apt-get install python3-cryptography-vectors python3-gmpy2 --yes

RUN apt-get install vim metasploit-framework --yes
RUN apt-get install set --yes

# Screengrab for msfconsole
RUN apt-get install screengrab --yes

# Tools
RUN apt-get install --yes 	net-tools \
				iputils-ping \
				tor \
				hydra \
				wordlists \
				testssl.sh \
				sublist3r

# Azurehound
RUN cd /usr/local/bin && wget https://github.com/BloodHoundAD/AzureHound/releases/download/v1.2.0/azurehound-linux-$ARCH.zip && unzip azurehound-linux-arm64.zip && rm -f azurehound-linux-arm64.zip && cd -

# Bloodhound
# RUN apt-get install --yes bloodhound
# Commented out since bloodhound segfaults for some reason....

# waybackurls
RUN apt-get install golang --yes
RUN echo "export GOPATH=/usr/lib/go" >> /root/.bashrc
RUN export GOPATH=/usr/lib/go; go install github.com/tomnomnom/waybackurls@latest
RUN ln -s /usr/lib/go/bin/waybackurls /usr/local/bin/

# SSH
RUN apt-get install openssh-server --yes
RUN echo '# Added at docker build time\nMatch Address 172.17.0.0/16\n\tPermitRootLogin yes' >> /etc/ssh/sshd_config
RUN service ssh start

RUN mkdir -p /root/.ssh && chmod 600 /root/.ssh
ADD id_*.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

ENTRYPOINT service ssh restart && /bin/bash
