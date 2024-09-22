FROM ubuntu:latest

#Install dependecies
RUN apt update && apt upgrade -y

#For some reason whem python calculute expression import some libraries like rasterio it crash beacause libexpat1 can't be found
#Installing it with apt was the solution found

RUN apt install curl libexpat1 -y

WORKDIR /root/DinamicaEgo/
COPY ./tests/ tests/

#Install DinamcaEGO
RUN curl https://dinamicaego.com/nui_download/1792/ -o ./DinamicaEgo-780.AppImage \
        #Grant excution permision
        && chmod +x ./DinamicaEgo.AppImage \
        #Extract AppImage
        && ./DinamicaEgo.AppImage --appimage-extract \
        #Remove the AppImage
        && rm -rf ./DinamicaEgo.AppImage
        
#Replace the launcher script       
COPY ./DinamcaEGO.sh /root/DinamicaEgo/squashfs-root/usr/bin/DinamcaEGO.sh

#DinamicaConsole tem problemas com nome de arquivos diretamente no funtor. Devem ser fornecidos por um filename
ENTRYPOINT [ "/bin/bash" ]
