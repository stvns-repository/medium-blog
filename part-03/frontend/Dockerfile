FROM nginx:stable-alpine

# Copy our static html to the default nginx path
COPY src/index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]