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
							sublist3r \
							ldapscripts

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

# Add user and make sure to update /etc/shadow with the right password hash
RUN useradd -rm -d /home/user -s /bin/bash -G sudo user
COPY shadow.txt /root/
RUN touch /root/shadow
RUN chmod $(stat -c %a /etc/shadow) /root/shadow
RUN chown $(stat -c %U /etc/shadow):$(stat -c %G /etc/shadow) /root/shadow
RUN cat /etc/shadow | egrep -v "^user:" > /root/shadow
RUN cat /root/shadow.txt >> /root/shadow
RUN rm /root/shadow.txt
RUN mv /root/shadow /etc/shadow

# Prepare everything for SSH, but don't start it
RUN apt-get install openssh-server --yes
RUN service ssh start
# This is a hint that you should start the container with -p 2222:22
EXPOSE 22

RUN mkdir -p /home/user/.ssh
RUN chmod 700 /home/user/.ssh
ADD id_rsa.pub /home/user/.ssh/authorized_keys
RUN chmod 600 /home/user/.ssh/authorized_keys
RUN chown user:user /home/user/.ssh/
RUN chown user:user /home/user/.ssh/authorized_keys

ENTRYPOINT /bin/bash
