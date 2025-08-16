FROM ubuntu:22.04

# Install Apache, MySQL client, and needed modules
RUN apt-get update && apt-get install -y apache2 libapache2-mod-fcgid cgiwrap mysql-client

# Enable CGI and fcgid modules
RUN a2enmod cgi fcgid

# Copy your static frontend files
COPY htmlpart /var/www/html/Banksystem/htmlpart
COPY csspart /var/www/html/Banksystem/csspart
COPY jspart /var/www/html/Banksystem/jspart
COPY img /var/www/html/img

# Copy CGI executables
COPY ../cgi-bin /var/www/cgi-bin

# Copy MySQL dump file if needed (optional, for backups or initial imports)
COPY ../bms.sql /var/www/html/bms.sql

# Set permissions for CGI executables
RUN chmod -R +x /var/www/cgi-bin

# Set ownership so Apache can access the files
RUN chown -R www-data:www-data /var/www/html/Banksystem /var/www/cgi-bin /var/www/html/img /var/www/html/bms.sql

# Expose HTTP port
EXPOSE 80

# Start Apache in foreground
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
