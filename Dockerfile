FROM kalilinux/kali
RUN apt update -y
RUN apt install -y mc curl iptables net-tools procps inetutils-ping vim openjdk-11-jre-headless
RUN apt install -y python3 metasploit-framework
ADD https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py /bin/systemctl
RUN chmod +x /bin/systemctl