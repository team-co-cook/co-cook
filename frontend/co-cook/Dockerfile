#use nginx image
FROM nginx

RUN mkdir /front_app

WORKDIR /front_app

# make directory /front_app/build 
RUN mkdir ./build

ADD ./dist ./build

# delete nginx default.conf
RUN rm /etc/nginx/conf.d/default.conf

# cp nginx.conf in host PC
COPY ./nginx.conf /etc/nginx/conf.d

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
