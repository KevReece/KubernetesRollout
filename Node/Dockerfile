FROM nginx:latest

COPY ./Node/nginx.conf /etc/nginx/nginx.conf
COPY ./Node/index.html /usr/share/nginx/html/index.html

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]