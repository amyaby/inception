# Use Alpine Linux 3.18 as the base image (lightweight and secure)
FROM alpine:3.18

# Update package lists, upgrade installed packages, and install NGINX and OpenSSL
# '--no-cache' avoids storing unnecessary package cache, keeping the image small
RUN apk update && apk upgrade && apk add --no-cache nginx openssl

# Create directory for SSL certificates
RUN mkdir -p /etc/nginx/ssl

# Create web root directory and add a test file
RUN mkdir -p /var/www/html && \
    echo "<h1>Nginx is working!</h1><p>Container is running successfully.</p>" > /var/www/html/index.html && \
    echo "Nginx test page" > /var/www/html/test.html

# Generate a self-signed SSL certificate and key with 4096-bit RSA and SHA256
RUN openssl req -x509 -nodes -days 365 -newkey rsa:4096 -sha256 \
    -out /etc/nginx/ssl/inception.crt \
    -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=MA/ST=Settat/L=Settat/O=42/OU=42/CN=iabasala.42.fr/UID=iabasala"

# Create directory required by NGINX to run properly in Alpine
RUN mkdir -p /run/nginx

# Copy the custom NGINX configuration file to the appropriate location in the container
COPY conf/nginx.conf /etc/nginx/http.d/default.conf

# Inform Docker that the container will listen on port 443 (HTTPS)
EXPOSE 443

# Start NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]
