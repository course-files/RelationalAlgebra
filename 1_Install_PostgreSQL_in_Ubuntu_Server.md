# Installing PostgreSQL in Ubuntu Server

## <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/linux/linux-original.svg" width="40" /> <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/ubuntu/ubuntu-original-wordmark.svg" width="40" /> Install Ubuntu Server in VirtualBox

- **Step 1:** Download Ubuntu Server 26.04 LTS from here: [https://ubuntu.com/download/server](https://ubuntu.com/download/server)

- **Step 2:** Download and install VirtualBox from here: [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)

  - Also download the VirtualBox Extension Pack from the same site

- **Step 3:** Create a new Virtual Machine (VM) in VirtualBox and install Ubuntu Server using the downloaded ISO file. Use the following settings when creating the VM:

  - VM Name: `ubuntu-26-04-server`
  - Base Memory: 4096 MB
  - Number of CPUs: 2
  - Disk Size: 25 GB (dynamically allocated)
  - Network: Bridged Adapter

- **Step 4:** Start the VM and follow the installation prompts to install Ubuntu Server. Most of the settings can be left in their default state. Settings that can be customized include:

  - Your name: `student`
  - Your server's name: `classlab`
  - Username: `student`
  - Password: `student`

### Install Guest Additions

Install the Guest Additions in VirtualBox to enable features like shared clipboard and drag-and-drop between your host machine and the VM.

```bash
sudo apt update
sudo apt install virtualbox-guest-utils virtualbox-guest-x11
sudo reboot
```

You can then turn on the following features in VirtualBox under the Device menu:

- Shared Clipboard: Bidirectional
- Drag and Drop: Bidirectional

### Install OpenSSH Server in Ubuntu

- **Step 1:** Execute the following commands to install the OpenSSH server:

```bash
sudo apt update
sudo apt install openssh-server
```

- **Step 2:** Verify installation:

```bash
ssh -V
systemctl status ssh
```

- **Step 3:** Start the SSH server

```bash
sudo systemctl start ssh
```

Set the SSH server to start automatically on boot

```bash
sudo systemctl enable ssh
```

- **Step 4:** Add a firewall rule for SSH access

Allow SSH traffic to pass through the **UFW (Uncomplicated Firewall)** - the default for UFW is to **deny all**, then explicitly allow

Add the firewall rule to allow access through port 22 by executing:

```bash
sudo ufw allow ssh
```

Enable the firewall:

```bash
sudo ufw enable
```

Confirm that the firewall has been enabled:

```bash
sudo ufw status verbose
```

- **Step 5:** **Harden** SSH access

```bash
sudo vim /etc/ssh/sshd_config
```

Then add the following under the **Authentication** section:  
`PermitRootLogin no`

To edit content in `vim`, press `i` to enter insert mode, make your changes, then press `Esc` to exit insert mode, and type `:wq` to save and quit.

Then restart the SSH service to apply the changes:

```bash
sudo systemctl restart ssh
```

- **Step 6:** Test SSH access

Next, find the IP address of your VM. This requires you to have `net-tools` installed first:

```bash
sudo apt install net-tools
```

Then execute:

```bash
ip addr show
```

Note the IP address assigned to the `enp0s3` interface. `enp0s3` stands for Ethernet adapter located on PCI bus 0, slot 3.

Below is an example of the output you should see:

```text
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:22:33:31 brd ff:ff:ff:ff:ff:ff
    altname enx080027223331
    inet 10.4.183.27/25 metric 100 brd 10.4.183.127 scope global dynamic enp0s3
       valid_lft 27681sec preferred_lft 27681sec
    inet6 fe80::a00:27ff:fe22:3331/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever
```

In this example, the IP address of the VM is `10.4.183.27`. **Replace this with the actual IP address of your VM when executing the following commands.**

Ping the VM from your host machine to confirm connectivity:

```bash
ping 10.4.183.27
```

You can now SSH into your VM from your host machine using:

```bash
ssh student@10.4.183.27
```

This is executed from your host machine's terminal. Use the Git Bash terminal if you are on Windows and the default terminal if you are on Linux or macOS.

You will be prompted to enter the password for the `student` user, which you set during the Ubuntu Server installation.

## <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/postgresql/postgresql-original-wordmark.svg" width="40" /> Install PostgreSQL

- **Step 1:** Follow the instructions provided here to install PostgreSQL in Ubuntu Server: [https://www.postgresql.org/download/linux/ubuntu/](https://www.postgresql.org/download/linux/ubuntu/), i.e., execute

```bash
sudo su
```

Install the server:

```bash
apt install postgresql
```

Install the client:

```bash
apt install postgresql-client
```

- **Step 2:** Start and enable the service

Start the PostgreSQL service:

```bash
sudo systemctl start postgresql
```

Enable the PostgreSQL service to start on boot:

```bash
sudo systemctl enable postgresql
```

- **Step 3** — Verify the installation

```bash
psql --version
sudo systemctl status postgresql
```

- **Step 4** — Set a password for the postgres user

```bash
sudo -u postgres psql
```

Inside the `psql` prompt, type:

```sql
ALTER USER postgres PASSWORD 'your_password_here';
\q
```

> Replace `your_password_here` with a password of your choice. Do not forget it.

- **Step 5:** Add a firewall rule for access to PostgreSQL

Allow PostgreSQL traffic to pass through the **UFW (Uncomplicated Firewall)** - the default for UFW is to **deny all**, then explicitly allow

Add the firewall rule to allow access through port 5432 by executing:

```bash
sudo ufw allow 5432/tcp
```

Enable the firewall:

```bash
sudo ufw enable
```

Confirm that the firewall has been enabled:

```bash
sudo ufw status verbose
```

You should see an output similar to:

```text
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere                  
5432/tcp                   ALLOW IN    Anywhere                  
22/tcp (v6)                ALLOW IN    Anywhere (v6)             
5432/tcp (v6)              ALLOW IN    Anywhere (v6)   
```

For a classroom setup (learning environment), opening port 5432 to all sources is acceptable within an isolated virtual machine environment. However, in production environments, database ports should be restricted to trusted IP addresses only.

Example allowing access only from a specific host:

```bash
sudo ufw allow from 192.168.56.1 to any port 5432 proto tcp
```

In this example, an Information System can be installed and running on the server with the IP address `192.168.56.1`. Only that server will be able to connect to the PostgreSQL database server running in the VM. This is a more secure configuration for production environments.

---

## Edit the PostgreSQL Configuration File

Firewall Rule Alone Is Not Enough

Opening the port in the firewall does not guarantee remote access. PostgreSQL must also be configured to listen for network connections.

- **Step 1:** Edit `postgresql.conf`  

```bash
sudo vim /etc/postgresql/*/main/postgresql.conf
```

Change the `listen_addresses` setting under the **CONNECTIONS AND AUTHENTICATION** section:

From:

```text
#listen_addresses = 'localhost'
```

To:

```text
listen_addresses = '*'
```

Save and exit the file.

- **Step 2:** Edit `pg_hba.conf`

```bash
sudo vim /etc/postgresql/*/main/pg_hba.conf
```

Add the following line at the end of the file to allow remote connections from any IP address:

host    all    all    0.0.0.0/0    scram-sha-256

In a production environment, you should restrict access to trusted IP addresses only. For example, if you want to allow access only from the IP address `192.168.56.1`:

```text
host    all    all    192.168.56.1/32    scram-sha-256
```

or a trusted subnet:

```text
host    all    all    192.168.56.0/24    scram-sha-256
```

- **Step 3:** Restart PostgreSQL

```bash
sudo systemctl restart postgresql
```

Confirm that the service has restarted successfully:

```bash
sudo systemctl status postgresql
```

- **Step 4:** Verify that PostgreSQL is listening on the correct port and accepting connections

```bash
sudo netstat -plnt | grep postgres
```

You should see an output similar to:

```text
tcp        0      0 0.0.0.0:5432      0.0.0.0:*         LISTEN      6771/postgres       
tcp6       0      0 :::5432           :::*              LISTEN      6771/postgres 
```

---

## Connect via psql (Command Line)

The `psql` tool is PostgreSQL's built-in command-line interface. It is useful for scripting and quick queries.

```bash
psql -U postgres -h localhost
```

Enter your password when prompted. You should see a prompt like:

```bash
postgres=#
```

Try the following commands:

```sql
-- List all databases
\l

-- Show the current PostgreSQL version
SELECT version();

-- Exit psql
\q
```

## Connect via pgAdmin (Graphical User Interface)

pgAdmin is a popular graphical interface for managing PostgreSQL databases. You can download it from here: [https://www.pgadmin.org/download/](https://www.pgadmin.org/download/).

Install pgAdmin on your host machine and connect to your PostgreSQL server running in the VM. Follow the steps below to set up the connection:

- **Step 1:** **Launch pgAdmin 4.** On the first launch, it will prompt you to set a master password for pgAdmin itself (this is separate from your PostgreSQL password).

- **Step 2:** In the left panel, right-click on **Servers** → **Register** → **Server…**

- **Step 3:** In the **General** tab:
  - **Name:** `postgres@ubuntu-16-04-VM:5432` (or any name you prefer)

- **Step 4:** In the **Connection** tab, fill in:
  - **Host name/address:** `<IP_ADDRESS_OF_YOUR_VM>` (e.g., 10.4.183.27)
  - **Port:** `5432`
  - **Maintenance database:** `postgres`
  - **Username:** `postgres`
  - **Password:** *(the password you set during installation)*
  - Check **Save password** for convenience during the subsequent labs.

- **Step 5:** Click **Save**.

- **Step 6:** In the left panel, expand **Servers → Local PostgreSQL → Databases**. You should see the default `postgres` database.

---

## Create a Database using pgAdmin 4

- **Step 1:** In pgAdmin 4, right-click on **Databases** → **Create** → **Database…**
- **Step 2:** In the **Database** field, enter your student ID followed by the course code, e.g., `123456_mcs8104` or `123456_dat2201`
- **Step 3:** Leave all other settings as default and click **Save**.
- **Step 4:** Your new database will appear in the left panel under **Databases**.

---

## Run a Query Using the Query Tool

- **Step 1:** Click on your newly created database to select it.
- **Step 2:** In the menu bar, click **Tools** → **Query Tool** (or press `Alt+Shift+Q`).
- **Step 3:** In the query editor that opens, type the following:

```sql
-- Create a simple test table
CREATE TABLE test_table (
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);
```

- **Step 4:** Highlight all the text and press **F5** (or click the **Execute** button — the play icon ▶).

- **Step 5:** In the query editor that opens, type the following:

```sql
-- Insert a record
INSERT INTO test_table (name) VALUES ('Hello, PostgreSQL!');

-- Retrieve the record
SELECT * FROM test_table;
```

- **Step 6:** Highlight all the text and press **F5** (or click the **Execute** button — the play icon ▶).

- **Step 7:** The **Data Output** panel at the bottom should show one row with your inserted record.

- **Step 8:** In the query editor that opens, type the following:

```sql
-- Clean up
DROP TABLE test_table;
```

- **Step 9:** Highlight all the text and press **F5** (or click the **Execute** button — the play icon ▶).

> **Note:** In pgAdmin, you can run individual statements by highlighting just that statement before pressing F5.

---

## Lab Deliverable

Take a screenshot showing:

1. A successful connection to PostgreSQL via a Command Line Interface (CLI) (`psql`) through the SSH terminal session.
2. pgAdmin 4 open with your named database visible in the left panel.
3. The Query Tool showing the `SELECT * FROM test_table;` result (before the `DROP`).

Submit both screenshots via the course portal by the deadline stated on the Lab Sheet.

---

## Troubleshooting

| Problem                                          | Likely Cause                                                | Solution                                                                                                |
| ------------------------------------------------ | ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| `psql: error: connection refused`                | PostgreSQL service is not running                           | Run `sudo systemctl start postgresql`                                                                   |
| `password authentication failed`                 | Incorrect password                                          | Reset the password using `ALTER USER postgres PASSWORD 'new_password';` through `sudo -u postgres psql` |
| pgAdmin cannot connect                           | Firewall is blocking port `5432`                            | Allow PostgreSQL traffic through the firewall using `sudo ufw allow 5432/tcp`                           |
| `could not connect to server: No route to host`  | VM networking or host reachability issue                    | Verify VM network mode (Bridged/NAT) and confirm the VM IP address is reachable                         |
| PostgreSQL listens only on `127.0.0.1`           | `listen_addresses` not configured correctly                 | Set `listen_addresses = '*'` in `postgresql.conf` and restart PostgreSQL                                |
| Connection hangs indefinitely                    | Port forwarding or firewall silently dropping packets       | Test connectivity using `Test-NetConnection <VM-IP> -Port 5432` from the host machine                   |
| `FATAL: no pg_hba.conf entry`                    | Client IP/network not allowed in `pg_hba.conf`              | Add an appropriate `host` rule and reload PostgreSQL configuration                                      |
| Changes appear ignored                           | PostgreSQL service not restarted after configuration update | Run `sudo systemctl restart postgresql`                                                                 |
| pgAdmin connects locally but not remotely        | PostgreSQL accessible only through localhost                | Confirm PostgreSQL is listening on `0.0.0.0:5432` using `ss -tulnp \| grep 5432`                        |
| Credentials work in terminal but fail in pgAdmin | Incorrect pgAdmin connection settings                       | Verify host, port, username, maintenance database, and saved password settings                          |
