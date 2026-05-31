FROM nginx:alpine

COPY cicd-prject.html /usr/share/nginx/html/index.html

EXPOSE 80