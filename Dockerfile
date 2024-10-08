FROM ubuntu:latest

#Install dependecies
RUN apt update && apt upgrade -y

#For some reason whem python calculute expression import some libraries like rasterio it crash beacause libexpat1 can't be found
#Installing it with apt was the solution found

RUN apt install curl libexpat1 -y

WORKDIR /root/DinamicaEgo/
COPY ./tests/ tests/

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/root/DinamicaEgo/squashfs-root/usr/lib
#Install DinamcaEGO
RUN curl https://dinamicaego.com/nui_download/1792/ -o ./DinamicaEgo.AppImage \
        #Grant excution permision
        && chmod +x ./DinamicaEgo.AppImage \
        #Extract AppImage
        && ./DinamicaEgo.AppImage --appimage-extract \
        #Remove the AppImage
        && rm -rf ./DinamicaEgo.AppImage
        
#Replace the launcher script       
COPY ./scripts/DinamicaEGO.sh /root/DinamicaEgo/squashfs-root/usr/bin/DinamicaEGO.sh

#DinamicaConsole tem problemas com nome de arquivos diretamente no funtor. Devem ser fornecidos por um filename
ENTRYPOINT [ "/bin/bash" ]
