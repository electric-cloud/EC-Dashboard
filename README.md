# EC-Dashboard
This plugin provides a template for creating custom dashboards for Electric Flow using Dashing.

## Install Dashing
The following instructions for installing Dashing are for Ubuntu

```bash
sudo apt-get -y install ruby-dev
sudo apt-get -y install g++
sudo gem install bundle
sudo gem install dashing
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs
```

## Create a custom dashboard plugin from EC-Dashboard template
1. Copy directory, e.g., cp -r EC-Dashboard MyDashboard
2. Decide on a version number, e.g., 1.0, so plugin name is MyDashboard-1.0
3. Edit META-INF/plugin.xml (key and version) and META-INF/project.xml (projectName) with this information
4. Edit META-INF/project.xml to select a port number for your plugin, my $portNumber = 3030;
5. htdocs/index.html to use this port number
6. Edit htdocs/help.xml to include your plugin name in the link to index.html
7. Create your custom dashboard and jobs in the dashing directory
8. Zip up the directories
9. Change extension to .jar
10. Import plugin and promote
11. Use the link in the help to open the dashboard

