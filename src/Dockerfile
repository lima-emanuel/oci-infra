FROM node:22

RUN apt update
RUN wget https://mega.nz/linux/repo/Debian_12/arm64/megacmd-Debian_12_arm64.deb
RUN apt install -y "$PWD/megacmd-Debian_12_amd64.deb"
RUN rm "$PWD/megacmd-Debian_12_amd64.deb"

# Set the foundry install home
RUN adduser -D foundry
RUN mkdir -p /home/foundry/fvtt
RUN mkdir -p /home/foundry/fvttdata

ENV FOUNDRY_HOME=/home/foundry/fvtt
ENV FOUNDRY_DATA=/home/foundry/fvttdata

WORKDIR "${FOUNDRY_DATA}"
RUN mega-get https://mega.nz/file/YaUHTSLQ#6XWcGsHSLVgNhqTHNc4pyUm-KWxUIElXZO_VIVmKG4I .
RUN tar -xf foundry_data.rar
RUN rm foundry_data.rar

WORKDIR "${FOUNDRY_HOME}"
RUN mega-get https://mega.nz/file/xC9lUTQK#PROlMeggBocK7OD3UdW6xrdSFofJRy2-AwxoSnwQvUU .
RUN tar -xf foundryvtt.zip
RUN rm foundryvtt.zip

EXPOSE 30000
CMD node main.js --dataPath=${FOUNDRY_DATA}
