# System Parameter Monitoring Script

This project is designed to automate the monitoring of critical system parameters on a server. It generates a detailed report that includes disk space usage, web service statuses, and log file summaries. The script is intended to assist system administrators in maintaining server health and quickly identifying potential issues.

## Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Technologies](#technologies)
- [File Output](#file-output)
- [License](#license)

## Features

- **Disk Space Monitoring**: Logs the current disk space usage.
- **Web Services Monitoring**: Checks and logs the status of specified web services.
- **Log Files Monitoring**: Summarizes the number and size of log files in a specified directory.
- **Email Notification**: Sends the report via email twice a day in a well-formatted HTML message.

## Installation

1. **Save the script file:**

   Save the script in a directory of your choice. Example:
   ```bash
   /usr/local/bin/systemreport.sh
   ```

2. **Make the script executable:**
   ```bash
   chmod +x /usr/local/bin/systemreport.sh
   ```

3. **Create directory for log files (optional):**
   ```bash
   mkdir -p /usr/local/bin/systemreport
   ```

4. **Configure email settings:**

   Ensure `msmtp` is installed and configure it as follows:
   ```bash
   sudo apt-get install msmtp
   sudo nano /etc/msmtprc
   ```
   Example configuration:
   ```bash
   defaults
   tls on
   tls_trust_file /etc/ssl/certs/ca-certificates.crt

   account default
   host smtp.example.com
   from your-email@example.com
   auth on
   user your-username
   password your-password
   logfile ~/.msmtp.log
   ```
5. **Configure crontab:**

    Open the `crontab` settings in sudo mode:
    ```shell
    sudo crontab -e
    ```

    Underneath the comment section, add the following entry:
    ```shell
    0 6 * * * /usr/local/bin/systemreport.sh >/dev/null 2>&1
    0 13 * * * /usr/local/bin/systemreport.sh >/dev/null 2>&1
    ```

## Usage

- Run the script with the following command:

   ```bash
   /usr/local/bin/systemreport.sh
   ```

## Technologies
- **Bash:** The scripting language used to write the script.
- **msmtp:** A lightweight SMTP client used to send email notifications.
- **crontab:** A time-based job scheduler.

## File Output

```
########################################
###                                  ###
###             CAPTEST              ###
###                -                 ###
###            06.06.2024            ###
###              14:30               ###
###                                  ###
########################################

         DISK SPACE USAGE:

       Size | Used | Avail | Use%
        50G |  10G |  40G  | 20%

########################################

              WEBSERVICES:

 Service1 ............................OK
 ---------------------------------------
 Service2 ........................!DOWN!

########################################

               LOGFILES:

 capsit.log......................2 Files
  - 1.1M | Jun  6 10:20 | capsit.log
  - 1.0M | Jun  6 09:15 | capsit.log
    ...
 ---------------------------------------
 pl6565..........................5 Files
  - 500K | Jun  6 11:30 | pl6565
  - 480K | Jun  6 11:00 | pl6565
    ...

########################################
```

## License

- This script is licensed under the MIT License. For more information, see the [LICENSE](./LICENSE) file.
