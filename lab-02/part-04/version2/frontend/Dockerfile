FROM nginx:stable-alpine

# Copy the config first
COPY default.conf /etc/nginx/conf.d/default.conf

# Copy your HTML (adjusting path to your 'src' folder)
COPY src/index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]