FROM ubuntu:latest

RUN apt update && apt upgrade
RUN apt install curl libfuse2t64

RUN curl https://dinamicaego.com/nui_download/1792/ -o DinamicaEgo-780.AppImage


